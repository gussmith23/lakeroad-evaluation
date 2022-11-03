"""Utilities for running hardware compilation.

By hardware compilation, we mean hardware synthesis, placement, and routing
using "traditional" tools like Vivado, Yosys, and nextpnr."""
from pathlib import Path
from typing import Union
import subprocess
import os
import logging
from time import time
from tempfile import TemporaryDirectory


def xilinx_ultrascale_plus_vivado_synthesis(
    instr_src_file: Union[str, Path],
    synth_opt_place_route_output_filepath: Union[str, Path],
    module_name: str,
    time_filepath: Union[str, Path],
    log_path: Union[str, Path] = os.devnull,
):
    log_path.parent.mkdir(parents=True, exist_ok=True)
    synth_opt_place_route_output_filepath.parent.mkdir(parents=True, exist_ok=True)

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
                Path(__file__).resolve().parent.parent
                / "tcl"
                / "synthesize_instruction_vivado.tcl",
                "-tclargs",
                instr_src_file,
                module_name,
                synth_opt_place_route_output_filepath,
            ],
            check=True,
            stdout=logfile,
            stderr=logfile,
        )
        end_time = time()

    with open(time_filepath, "w") as f:
        print(f"{end_time-start_time}s", file=f)


def make_xilinx_ultrascale_plus_vivado_synthesis_task(
    input_filepath: Union[str, Path],
    output_dirpath: Union[str, Path],
    module_name: str,
):
    """Wrapper over Vivado synthesis function which creates a DoIt task."""

    input_filepath = Path(input_filepath)
    output_dirpath = Path(output_dirpath)
    synth_opt_place_route_output_filepath = output_dirpath / input_filepath.name
    time_filepath = output_dirpath / f"{input_filepath.stem}.time"
    log_filepath = output_dirpath / f"{input_filepath.stem}.log"

    return {
        "actions": [
            (
                xilinx_ultrascale_plus_vivado_synthesis,
                [
                    input_filepath,
                    synth_opt_place_route_output_filepath,
                    module_name,
                    time_filepath,
                    log_filepath,
                ],
            )
        ],
        "file_dep": [input_filepath],
        "targets": [
            synth_opt_place_route_output_filepath,
            time_filepath,
            log_filepath,
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

    with open(yosys_time_path, "w") as f:
        print(f"{yosys_end_time-yosys_start_time}s", file=f)

    # Place and route with nextpnr.
    # Runs in out-of-context mode, which doesn't insert I/O cells.
    with open(nextpnr_log_path, "w") as logfile:
        logging.info("Running nextpnr place-and-route on %s", instr_src_file)
        nextpnr_start_time = time()
        subprocess.run(
            ["nextpnr-ecp5", "--out-of-context", "--json", synth_out_json],
            check=True,
            stdout=logfile,
            stderr=logfile,
        )
        nextpnr_end_time = time()

    with open(nextpnr_time_path, "w") as f:
        print(f"{nextpnr_end_time-nextpnr_start_time}s", file=f)


def lattice_ecp5_diamond_synthesis(
    src_filepath: Union[Path, str], module_name: str, output_dirpath: Union[Path, str]
):
    output_dirpath = Path(output_dirpath)
    output_dirpath.mkdir(parents=True, exist_ok=True)

    # Diamond's synthesis routine won't accept things with a .sv suffix, so we
    # copy the file and give it a new name.
    tmp_verilog_filepath = output_dirpath / f"{module_name}_orig.v"
    subprocess.run(["cp", src_filepath, tmp_verilog_filepath], check=True)

    assert (
        "DIAMOND_BINDIR" in os.environ
    ), "DIAMOND_BINDIR environment variable must be set to the directory containing Lattice Diamond binaries, e.g. /usr/local/diamond/3.12/bin/lin64"

    # Run synthesis. Set cwd to the output, as Diamond seems to output its
    # results to the cwd.
    env = os.environ.copy()
    env["bindir"] = os.environ["DIAMOND_BINDIR"]
    subprocess.run(
        ["bash", "-c", "source $bindir/diamond_env && synthesis -a ECP5U -ver " + str(tmp_verilog_filepath)],
        check=True,
        stdout=subprocess.DEVNULL,
        cwd=output_dirpath,
        env=env,
    )


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
            output_dirpath / f"{module_name}_orig.v",
            output_dirpath / f"{module_name}_prim.v",
            output_dirpath / f"{module_name}_drc.log",
            output_dirpath / f"synthesis.log",
        ],
    }
