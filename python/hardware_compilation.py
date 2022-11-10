"""Utilities for running hardware compilation.

By hardware compilation, we mean hardware synthesis, placement, and routing
using "traditional" tools like Vivado, Yosys, and nextpnr."""
from pathlib import Path
import sys
from typing import Union
import subprocess
import os
import logging
from time import time


def xilinx_ultrascale_plus_vivado_synthesis(
    instr_src_file: Union[str, Path],
    synth_opt_place_route_output_filepath: Union[str, Path],
    module_name: str,
    time_filepath: Union[str, Path],
    tcl_script_filepath: Union[str, Path],
    log_path: Union[str, Path] = os.devnull,
    directive: str = "default",
    synth_design: bool = True,
    opt_design: bool = True,
):
    """Synthesize with Xilinx Vivado.

    Args:
        tcl_script_filepath: Output filepath where .tcl script will be written.
        directive: What to pass to the -directive arg of Vivado's synth_design command.
        synth_design: Whether or not to run Vivado's synth_design command.
        opt_design: Whether or not to run Vivado's opt_design command.
    """
    log_path = Path(log_path)
    log_path.parent.mkdir(parents=True, exist_ok=True)
    synth_opt_place_route_output_filepath = Path(synth_opt_place_route_output_filepath)
    synth_opt_place_route_output_filepath.parent.mkdir(parents=True, exist_ok=True)
    tcl_script_filepath = Path(tcl_script_filepath)
    tcl_script_filepath.parent.mkdir(parents=True, exist_ok=True)

    # Generate and write the TCL script.
    with open(tcl_script_filepath, "w") as f:
        synth_design_command = (
            f"synth_design -mode out_of_context -directive {directive}"
        )
        f.write(
            f"""
set sv_source_file {str(instr_src_file)}
set modname {module_name}
set synth_opt_place_route_output_filepath {synth_opt_place_route_output_filepath}

# Part number chosen at Luis's suggestion. Can be changed to another UltraScale+
# part.
set_part xczu3eg-sbva484-1-e

read_verilog -sv ${{sv_source_file}}
set_property top ${{modname}} [current_fileset]
{synth_design_command if synth_design else f"# {synth_design_command}"}
{"opt_design" if opt_design else "# opt_design"}
place_design
# -release_memory seems to fix a bug where routing crashes when used inside the
# Docker container.
route_design -release_memory
write_verilog -force ${{synth_opt_place_route_output_filepath}}
report_timing_summary
"""
        )

    # Synthesis with Vivado.
    with open(log_path, "w") as logfile:
        logging.info("Running Vivado synthesis/place/route on %s", instr_src_file)
        start_time = time()
        subprocess.run(
            [
                "vivado",
                # -stack 2000 is a way to sometimes prevent mysterious Vivado
                # crashes...
                "-stack",
                "2000",
                "-mode",
                "batch",
                "-source",
                tcl_script_filepath,
            ],
            check=True,
            stdout=logfile,
            stderr=logfile,
        )
        end_time = time()

    with open(time_filepath, "w") as f:
        print(f"{end_time-start_time}s", file=f)


def make_xilinx_ultrascale_plus_vivado_synthesis_task_opt(
    input_filepath: Union[str, Path],
    output_dirpath: Union[str, Path],
    module_name: str,
):
    """Wrapper over Vivado synthesis function which creates a DoIt task.

    This task will run Vivado with optimizations."""

    input_filepath = Path(input_filepath)
    output_dirpath = Path(output_dirpath)
    synth_opt_place_route_output_filepath = output_dirpath / input_filepath.name
    time_filepath = output_dirpath / f"{input_filepath.stem}.time"
    log_filepath = output_dirpath / f"{input_filepath.stem}.log"
    tcl_script_filepath = output_dirpath / f"{input_filepath.stem}.tcl"

    return {
        "actions": [
            (
                xilinx_ultrascale_plus_vivado_synthesis,
                [],
                {
                    "instr_src_file": input_filepath,
                    "synth_opt_place_route_output_filepath": synth_opt_place_route_output_filepath,
                    "module_name": module_name,
                    "time_filepath": time_filepath,
                    "log_path": log_filepath,
                    "tcl_script_filepath": tcl_script_filepath,
                    "directive": "default",
                    "opt_design": True,
                },
            )
        ],
        "file_dep": [input_filepath],
        "targets": [
            synth_opt_place_route_output_filepath,
            time_filepath,
            log_filepath,
            tcl_script_filepath,
        ],
    }

def make_xilinx_ultrascale_plus_vivado_synthesis_task_noopt(
    input_filepath: Union[str, Path],
    output_dirpath: Union[str, Path],
    module_name: str,
):
    """Wrapper over Vivado synthesis function which creates a DoIt task.

    This task will run Vivado without optimizations, optimized for making
    synthesis fast."""

    input_filepath = Path(input_filepath)
    output_dirpath = Path(output_dirpath)
    synth_opt_place_route_output_filepath = output_dirpath / input_filepath.name
    time_filepath = output_dirpath / f"{input_filepath.stem}.time"
    log_filepath = output_dirpath / f"{input_filepath.stem}.log"
    tcl_script_filepath = output_dirpath / f"{input_filepath.stem}.tcl"

    return {
        "actions": [
            (
                xilinx_ultrascale_plus_vivado_synthesis,
                [],
                {
                    "instr_src_file": input_filepath,
                    "synth_opt_place_route_output_filepath": synth_opt_place_route_output_filepath,
                    "module_name": module_name,
                    "time_filepath": time_filepath,
                    "log_path": log_filepath,
                    "tcl_script_filepath": tcl_script_filepath,
                    "directive": "runtimeoptimized",
                    "opt_design": False,
                },
            )
        ],
        "file_dep": [input_filepath],
        "targets": [
            synth_opt_place_route_output_filepath,
            time_filepath,
            log_filepath,
            tcl_script_filepath,
        ],
    }


def lattice_ecp5_yosys_nextpnr_synthesis(
    instr_src_file: Union[str, Path],
    module_name: str,
    synth_out_sv: str,
    synth_out_json: str,
    yosys_time_path: Union[str, Path],
    nextpnr_time_path: Union[str, Path],
    yosys_log_path: Union[str, Path] = os.devnull,
    nextpnr_log_path: Union[str, Path] = os.devnull,
):
    synth_out_json.parent.mkdir(parents=True, exist_ok=True)
    synth_out_sv.parent.mkdir(parents=True, exist_ok=True)
    yosys_log_path.parent.mkdir(parents=True, exist_ok=True)
    nextpnr_log_path.parent.mkdir(parents=True, exist_ok=True)

    # Synthesis with Yosys.
    with open(yosys_log_path, "w") as logfile:
        logging.info("Running Yosys synthesis on %s", instr_src_file)
        try:
            yosys_start_time = time()
            subprocess.run(
                [
                    "yosys",
                    "-d",
                    "-p",
                    f"""
                    read -sv {instr_src_file}
                    hierarchy -top {module_name}
                    proc; opt; techmap; opt
                    synth_ecp5
                    write_json {synth_out_json}
                    write_verilog {synth_out_sv}""",
                ],
                check=True,
                stdout=logfile,
                stderr=logfile,
            )
            yosys_end_time = time()
        except subprocess.CalledProcessError as e:
            print(f"Error log in {(str(logfile))}", file=sys.stderr)
            raise e

    with open(yosys_time_path, "w") as f:
        print(f"{yosys_end_time-yosys_start_time}s", file=f)

    # Place and route with nextpnr.
    # Runs in out-of-context mode, which doesn't insert I/O cells.
    with open(nextpnr_log_path, "w") as logfile:
        logging.info("Running nextpnr place-and-route on %s", instr_src_file)
        try:
            nextpnr_start_time = time()
            subprocess.run(
                ["nextpnr-ecp5", "--out-of-context", "--json", synth_out_json],
                check=True,
                stdout=logfile,
                stderr=logfile,
            )
            nextpnr_end_time = time()
        except subprocess.CalledProcessError as e:
            print(f"Error log in {(str(logfile))}", file=sys.stderr)
            raise e

    with open(nextpnr_time_path, "w") as f:
        print(f"{nextpnr_end_time-nextpnr_start_time}s", file=f)


def lattice_ecp5_diamond_synthesis(
    src_filepath: Union[Path, str], module_name: str, output_dirpath: Union[Path, str]
):
    output_dirpath = Path(output_dirpath)
    output_dirpath.mkdir(parents=True, exist_ok=True)

    # Diamond's synthesis routine won't accept SystemVerilog, so we use sv2v to
    # convert.
    sv2v_result_filepath = output_dirpath / f"{module_name}.v"
    with open(sv2v_result_filepath, "w") as f:
        subprocess.run(["sv2v", src_filepath], check=True, stdout=f)

    assert (
        "DIAMOND_BINDIR" in os.environ
    ), "DIAMOND_BINDIR environment variable must be set to the directory containing Lattice Diamond binaries, e.g. /usr/local/diamond/3.12/bin/lin64"

    # Run synthesis. Set cwd to the output, as Diamond seems to output its
    # results to the cwd.
    env = os.environ.copy()
    env["bindir"] = os.environ["DIAMOND_BINDIR"]
    out = subprocess.run(
        [
            "bash",
            "-c",
            f"source $bindir/diamond_env && synthesis -top {module_name} -a ECP5U -ver "
            + str(sv2v_result_filepath),
        ],
        stdout=subprocess.DEVNULL,
        cwd=output_dirpath,
        env=env,
    ).returncode

    # Currently, Diamond will likely take issue with Calyx's designs when
    # running DRC. However, Diamond will still produce correct output. So we
    # ignore DRC errors.
    assert (
        out == 0 or out == 2
    ), f"Diamond failed with exit code {out}, indicating errors other than DRC errors."

    assert (output_dirpath / f"{module_name}_prim.v").exists()


def make_lattice_ecp5_diamond_synthesis_task(
    input_filepath: Union[str, Path],
    output_dirpath: Union[str, Path],
    module_name: str,
):
    """Wrapper over Diamond synthesis function which creates a DoIt task."""

    output_dirpath = Path(output_dirpath)

    return {
        "actions": [
            (
                lattice_ecp5_diamond_synthesis,
                [input_filepath, module_name, output_dirpath],
            )
        ],
        "file_dep": [input_filepath],
        "targets": [
            output_dirpath / f"{module_name}.arearep",
            # output_dirpath / f"{module_name}.lsedata",
            # output_dirpath / f"{module_name}.ngd",
            output_dirpath / f"{module_name}.v",
            output_dirpath / f"{module_name}_prim.v",
            output_dirpath / f"{module_name}_drc.log",
            output_dirpath / f"synthesis.log",
        ],
    }
