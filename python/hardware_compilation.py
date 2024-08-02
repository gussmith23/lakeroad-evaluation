"""Utilities for running hardware compilation.

By hardware compilation, we mean hardware synthesis, placement, and routing
using "traditional" tools like Vivado, Yosys, and nextpnr."""

import json
import logging
import os
import re
import subprocess
import sys
from dataclasses import dataclass
from datetime import datetime, timedelta
from pathlib import Path
from time import time
from typing import Any, Dict, Optional, Tuple, Union
from tempfile import NamedTemporaryFile
from quartus import IntelFamily


def count_resources_in_verilog_src(
    verilog_src: str, module_name: str
) -> Dict[str, int]:
    with NamedTemporaryFile(mode="w") as f:
        with f.file as file_object:
            file_object.write(verilog_src)

        out = subprocess.run(
            [
                "yosys",
                "-p",
                f"read_verilog {f.name}; hierarchy -top {module_name}; stat",
            ],
            capture_output=True,
            text=True,
            check=True,
        ).stdout

    # print(out)
    return parse_yosys_log(out)


@dataclass
class DiamondSynthesisStats:
    """Statistics about a synthesis run using Diamond.

    NOTE: it's important that this is not a nested dictionary, i.e. that all of
    the fields of this dictionary are strings/ints/floats and not lists/dicts.
    This is because each of these dictionaries becomes a row in a CSV file, and
    thus if there was a nested structure, it would get a lot more compilcated."""

    # Likely just the module name.
    identifier: str

    # Number of various primitives
    num_LUT4: int
    num_CCU2C: int
    num_PFUMX: int
    num_ALU54B: int
    num_MULT18X18D: int
    num_L6MUX21: int
    num_MULT9X9D: int

    # Runtime of Diamond
    diamond_cpu_time: float


def parse_diamond_log(log_text: str, identifier: str) -> DiamondSynthesisStats:
    """Parses a Diamond log.

    Specifically, parses whatever comes out of the `synthesis` binary in Diamond."""
    matches = list(
        re.finditer(
            r"""\#* Begin Area Report .*\#*
Number of register bits => .*?$
(?P<table_contents>.*)
\#* End Area Report""",
            log_text,
            flags=re.MULTILINE | re.DOTALL,
        )
    )
    assert len(matches) == 1
    span = matches[0].span("table_contents")

    matches = list(
        re.finditer(r"(?P<name>\w+) => (?P<value>\d+)", log_text[span[0] : span[1]])
    )
    primitives_dict = {match["name"]: int(match["value"]) for match in matches}

    # Make sure there aren't any primitives we don't know about. Wouldn't want
    # to let one slip through and not count it, if we care to count it!
    all_known_primitives_set = {
        "GSR",
        "IB",
        "LUT4",
        "OB",
        "CCU2C",
        "IFS1P3IX",
        "OFS1P3IX",
        "OFS1P3DX",
        "FD1P3IX",
        "FD1S3AX",
        "FD1S3IX",
        "PFUMX",
        "ALU54B",
        "MULT18X18D",
        "L6MUX21",
        "SPR16X4C",
        "MULT9X9D",
        "FD1P3AX",
        "OFS1P3JXI",
        "DP16KD",
        "OFS1P3JX",
        "IFS1P3DX",
        "DPR16X4C",  # "Distributed Pseudo Dual Port RAM"
    }
    if not set(primitives_dict.keys()).issubset(all_known_primitives_set):
        raise Exception(
            f"""Previously unseen primitive(s) {set(primitives_dict.keys()).difference(all_known_primitives_set)}, please determine if it should be logged and add it to all_known_primitives_set!"""
        )

    maybe_get = lambda k: primitives_dict[k] if k in primitives_dict else None
    num_LUT4 = maybe_get("LUT4")
    num_CCU2C = maybe_get("CCU2C")
    num_PFUMX = maybe_get("PFUMX")
    num_ALU54B = maybe_get("ALU54B")
    num_MULT18X18D = maybe_get("MULT18X18D")
    num_L6MUX21 = maybe_get("L6MUX21")
    num_MULT9X9D = maybe_get("MULT9X9D")

    matches = list(
        re.finditer(
            r"Elapsed CPU time for LSE flow : (?P<time>\d+\.\d+)  secs", log_text
        )
    )
    assert len(matches) == 1
    diamond_cpu_time = float(matches[0]["time"])

    return DiamondSynthesisStats(
        num_MULT9X9D=num_MULT9X9D,
        num_L6MUX21=num_L6MUX21,
        num_MULT18X18D=num_MULT18X18D,
        num_ALU54B=num_ALU54B,
        num_PFUMX=num_PFUMX,
        num_CCU2C=num_CCU2C,
        num_LUT4=num_LUT4,
        diamond_cpu_time=diamond_cpu_time,
        identifier=identifier,
    )


def xilinx_ultrascale_plus_vivado_synthesis(
    instr_src_file: Union[str, Path],
    synth_opt_place_route_output_filepath: Union[str, Path],
    module_name: str,
    tcl_script_filepath: Union[str, Path],
    log_path: Union[str, Path],
    summary_filepath: Union[str, Path],
    part_name: str,
    directive: str = "default",
    synth_design: bool = True,
    opt_design: bool = True,
    synth_design_rtl_flags: bool = False,
    clock_info: Optional[Tuple[str, float, Tuple[float, float]]] = None,
    place_directive: str = "default",
    route_directive: str = "default",
    extra_summary_fields: Dict[str, Any] = {},
    max_threads: int = 1,
    attempts: int = 1,
):
    """Synthesize with Xilinx Vivado.

    NOTE: We could use fud to do this; fud will allow you to provide a tcl and
    xdc file, and will parse out the results for you (which I still have to do.)

    Args:
        tcl_script_filepath: Output filepath where .tcl script will be written.
        directive: What to pass to the -directive arg of Vivado's synth_design
          command.
        synth_design: Whether or not to run Vivado's synth_design
          command.
        opt_design: Whether or not to run Vivado's opt_design command.
        synth_design_rtl_flags: Whether or not to pass the -rtl and all
          -rtl_skip_* flags to synth_design.
        summary_filepath: Output JSON summary filepath.
        clock_info: Clock name and period in nanoseconds. When provided, a
          constraint file will be created and loaded using the given clock
          information.
        extra_summary_fields: Extra fields to add to the summary JSON.
        attempts: Number of times to attempt running Vivado synthesis, in the
          case where Vivado fails (which occurs ~once per evaluation run).
        part_name: The part name to use for synthesis.
    """
    log_path = Path(log_path)
    log_path.parent.mkdir(parents=True, exist_ok=True)
    synth_opt_place_route_output_filepath = Path(synth_opt_place_route_output_filepath)
    synth_opt_place_route_output_filepath.parent.mkdir(parents=True, exist_ok=True)
    tcl_script_filepath = Path(tcl_script_filepath)
    tcl_script_filepath.parent.mkdir(parents=True, exist_ok=True)
    xdc_filepath = tcl_script_filepath.with_suffix(".xdc")

    with open(xdc_filepath, "w") as f:
        if clock_info:
            clock_name, clock_period, (rising_edge, falling_edge) = clock_info
            # We use 7 because that's what the Calyx team used for their eval.
            # We could try to refine the clock period per design. Rachit's notes:
            #
            set_clock_command = f"create_clock -period {clock_period} -name {clock_name} -waveform {{{rising_edge} {falling_edge}}} [get_ports {clock_name}]"
        else:
            set_clock_command = "# No clock provided; not creating a clock."
        f.write(set_clock_command)

    # Generate and write the TCL script.
    with open(tcl_script_filepath, "w") as f:
        synth_design_command = (
            f"synth_design -mode out_of_context -directive {directive}"
            + (
                " -rtl -rtl_skip_mlo -rtl_skip_ip -rtl_skip_constraints"
                if synth_design_rtl_flags
                else ""
            )
        )

        f.write(
            f"""
set sv_source_file {str(instr_src_file)}
set modname {module_name}
set synth_opt_place_route_output_filepath {synth_opt_place_route_output_filepath}

# Part number chosen at Luis's suggestion. Can be changed to another UltraScale+
# part.
set_part {part_name}

# Set number of threads.
set_param general.maxThreads {max_threads}

read_verilog -sv ${{sv_source_file}}
set_property top ${{modname}} [current_fileset]
{synth_design_command if synth_design else f"# {synth_design_command}"}
read_xdc -mode out_of_context {xdc_filepath}
{"opt_design" if opt_design else "# opt_design"}
place_design -directive {place_directive}
# route_design causes problems when run inside the Docker container. Originally,
# I used -release_memory, because I thought the issue was memory related. This
# fixed the issue, but only because (as I later discovered) -release_memory
# doesn't actually run routing! So we need to see if the crash still occurs, 
# and if it does, we need another way around it.
route_design -directive {route_directive}
write_verilog -force ${{synth_opt_place_route_output_filepath}}
report_timing_summary
report_utilization
"""
        )

    def _run_vivado():
        # Synthesis with Vivado.
        with open(log_path, "w") as logfile:
            logging.info("Running Vivado synthesis/place/route on %s", instr_src_file)

            # Setting this environment variable prevents an error when running
            # Vivado route_design inside a Docker container. See:
            # https://community.flexera.com/t5/InstallAnywhere-Forum/Issues-when-running-Xilinx-tools-or-Other-vendor-tools-in-docker/m-p/245820#M10647
            env = os.environ.copy()
            ld_preload_previous_value = env["LD_PRELOAD"] if "LD_PRELOAD" in env else ""
            env["LD_PRELOAD"] = (
                f"/lib/x86_64-linux-gnu/libudev.so.1:{ld_preload_previous_value}"
            )

            start_time = time()
            completed_process = subprocess.run(
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
                check=False,
                stdout=logfile,
                stderr=logfile,
                env=env,
            )
            end_time = time()
        return (completed_process, end_time - start_time)

    completed_process, elapsed_time = _run_vivado()
    attempts_remaining = attempts - 1
    # If Vivado failed, try again.
    while completed_process.returncode != 0 and attempts_remaining > 0:
        logging.error(
            "Vivado synthesis failed with return code %d. Attempts remaining: %d. Trying again...",
            completed_process.returncode,
            attempts_remaining,
        )
        completed_process, elapsed_time = _run_vivado()
        attempts_remaining = attempts_remaining - 1

    completed_process.check_returncode()

    summary = count_resources_in_verilog_src(
        verilog_src=synth_opt_place_route_output_filepath.read_text(),
        module_name=module_name,
    )

    assert "time_s" not in summary
    summary["time_s"] = elapsed_time

    for key in extra_summary_fields:
        assert key not in summary
        summary[key] = extra_summary_fields[key]

    json.dump(
        summary,
        fp=open(summary_filepath, "w"),
    )


def make_xilinx_ultrascale_plus_vivado_synthesis_task_opt(
    input_filepath: Union[str, Path],
    output_dirpath: Union[str, Path],
    module_name: str,
    part_name: str,
    clock_info: Optional[Tuple[str, float]] = None,
    name: Optional[str] = None,
    directive: Optional[str] = None,
    fail_if_constraints_not_met: Optional[bool] = None,
    extra_summary_fields: Dict[str, Any] = {},
    attempts: Optional[int] = None,
):
    """Wrapper over Vivado synthesis function which creates a DoIt task.

    This task will run Vivado with optimizations.

    Returns:
        (task, (json_filepath, verilog_filepath, log_filepath, tcl_filepath)).
    """

    input_filepath = Path(input_filepath)
    output_dirpath = Path(output_dirpath)

    output_filepaths = {
        "synth_opt_place_route_output_filepath": output_dirpath / input_filepath.name,
        "log_filepath": output_dirpath / f"{input_filepath.stem}.log",
        "tcl_script_filepath": output_dirpath / f"{input_filepath.stem}.tcl",
        "summary_filepath": output_dirpath / f"{input_filepath.stem}_summary.json",
    }

    synth_args = {
        "instr_src_file": input_filepath,
        "synth_opt_place_route_output_filepath": output_filepaths[
            "synth_opt_place_route_output_filepath"
        ],
        "module_name": module_name,
        "log_path": output_filepaths["log_filepath"],
        "tcl_script_filepath": output_filepaths["tcl_script_filepath"],
        "opt_design": True,
        "synth_design": True,
        "summary_filepath": output_filepaths["summary_filepath"],
        "extra_summary_fields": extra_summary_fields,
        "part_name": part_name,
    }

    if directive is not None:
        synth_args["directive"] = directive
    if clock_info is not None:
        synth_args["clock_info"] = clock_info
    if fail_if_constraints_not_met is not None:
        synth_args["fail_if_constraints_not_met"] = fail_if_constraints_not_met
    if attempts is not None:
        synth_args["attempts"] = attempts

    task = {
        "actions": [
            (
                xilinx_ultrascale_plus_vivado_synthesis,
                [],
                synth_args,
            )
        ],
        "file_dep": [input_filepath],
        "targets": list(output_filepaths.values()),
    }

    if name is not None:
        task["name"] = name

    return (
        task,
        (
            output_filepaths["summary_filepath"],
            output_filepaths["synth_opt_place_route_output_filepath"],
            output_filepaths["log_filepath"],
            output_filepaths["tcl_script_filepath"],
        ),
    )


def make_xilinx_ultrascale_plus_vivado_synthesis_task_noopt(
    input_filepath: Union[str, Path],
    output_dirpath: Union[str, Path],
    module_name: str,
    clock_info: Optional[Tuple[str, float]] = None,
    attempts: Optional[int] = None,
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
    json_filepath = output_dirpath / f"{input_filepath.stem}.json"

    synth_opts = {
        "instr_src_file": input_filepath,
        "synth_opt_place_route_output_filepath": synth_opt_place_route_output_filepath,
        "module_name": module_name,
        "time_filepath": time_filepath,
        "log_path": log_filepath,
        "tcl_script_filepath": tcl_script_filepath,
        "directive": "RuntimeOptimized",
        "place_directive": "RuntimeOptimized",
        "route_directive": "RuntimeOptimized",
        "opt_design": False,
        "synth_design": True,
        "synth_design_rtl_flags": False,
        "clock_info": clock_info,
        "json_filepath": json_filepath,
    }

    if attempts is not None:
        synth_opts["attempts"] = attempts

    return {
        "actions": [
            (
                xilinx_ultrascale_plus_vivado_synthesis,
                [],
                synth_opts,
            )
        ],
        "file_dep": [input_filepath],
        "targets": [
            synth_opt_place_route_output_filepath,
            time_filepath,
            log_filepath,
            tcl_script_filepath,
            json_filepath,
        ],
    }


def parse_yosys_log(log_txt: str):
    matches = list(
        re.finditer(
            r"""
   Number of cells:.*$
.*

""",
            log_txt,
            flags=re.DOTALL | re.MULTILINE,
        )
    )
    assert len(matches) == 1
    span = matches[0].span()
    matches = list(
        re.finditer(
            r"^     (?P<name>\w+) +(?P<count>\d+)$",
            log_txt[span[0] : span[1]],
            flags=re.MULTILINE,
        )
    )
    resources = {match["name"]: int(match["count"]) for match in matches}

    return resources


def yosys_synthesis(
    input_filepath: Union[str, Path],
    module_name: str,
    output_filepath: str,
    synth_command: str,
    log_filepath: Union[str, Path],
    summary_filepath: Union[str, Path],
    extra_summary_fields: Dict[str, Any] = {},
):
    output_filepath.parent.mkdir(parents=True, exist_ok=True)
    log_filepath.parent.mkdir(parents=True, exist_ok=True)

    # Synthesis with Yosys.
    with open(log_filepath, "w") as logfile:
        logging.info("Running Yosys synthesis on %s", input_filepath)
        try:
            yosys_start_time = time()
            subprocess.run(
                [
                    "yosys",
                    "-d",
                    "-p",
                    f"""
                    read -sv {input_filepath}
                    hierarchy -top {module_name}
                    {synth_command}
                    stat
                    write_verilog {output_filepath}""",
                ],
                check=True,
                stdout=logfile,
                stderr=logfile,
            )
            yosys_end_time = time()
        except subprocess.CalledProcessError as e:
            print(f"Error log in {(str(logfile.name))}", file=sys.stderr)
            raise e

    # Generate summary
    summary = count_resources_in_verilog_src(output_filepath.read_text(), module_name)

    assert "time_s" not in summary
    summary["time_s"] = yosys_end_time - yosys_start_time

    for key in extra_summary_fields:
        assert key not in summary
        summary[key] = extra_summary_fields[key]

    with open(summary_filepath, "w") as f:
        json.dump(summary, f)


def make_lattice_ecp5_yosys_synthesis_task(
    input_filepath: Union[str, Path],
    output_dirpath: Union[str, Path],
    module_name: str,
    clock_info: Optional[Tuple[str, float]] = None,
    name: Optional[str] = None,
    extra_summary_fields: Dict[str, Any] = {},
):
    """Wrapper over Yosys synthesis function which creates a DoIt task."""
    # TODO(@gussmith23): Support clocks on Lattice.
    if clock_info is not None:
        logging.warn("clock_info not supported for Lattice yet.")

    output_dirpath = Path(output_dirpath)
    json_filepath = output_dirpath / f"{module_name}.json"
    output_filepath = output_dirpath / f"{module_name}.sv"
    log_filepath = output_dirpath / f"{module_name}.log"

    task = {
        "actions": [
            (
                yosys_synthesis,
                [],
                {
                    "summary_filepath": json_filepath,
                    "input_filepath": input_filepath,
                    "module_name": module_name,
                    "output_filepath": output_filepath,
                    "synth_command": "synth_ecp5",
                    "log_filepath": log_filepath,
                    "extra_summary_fields": extra_summary_fields,
                },
            )
        ],
        "file_dep": [input_filepath],
        "targets": [
            json_filepath,
            output_filepath,
            log_filepath,
        ],
    }

    if name is not None:
        task["name"] = name

    return (task, (json_filepath, output_filepath, log_filepath))


def make_xilinx_yosys_synthesis_task(
    input_filepath: Union[str, Path],
    output_dirpath: Union[str, Path],
    module_name: str,
    family: str,
    clock_info: Optional[Tuple[str, float]] = None,
    name: Optional[str] = None,
    extra_summary_fields: Dict[str, Any] = {},
):
    """Wrapper over Yosys synthesis function which creates a DoIt task."""
    # TODO(@gussmith23): Support clocks on Lattice.
    if clock_info is not None:
        logging.warn("clock_info not supported for Yosys.")

    output_dirpath = Path(output_dirpath)
    output_filepaths = {
        "json_filepath": output_dirpath / f"{module_name}.json",
        "output_filepath": output_dirpath / f"{module_name}.sv",
        "log_filepath": output_dirpath / f"{module_name}.log",
    }

    task = {
        "actions": [
            (
                yosys_synthesis,
                [],
                {
                    "summary_filepath": output_filepaths["json_filepath"],
                    "input_filepath": input_filepath,
                    "module_name": module_name,
                    "output_filepath": output_filepaths["output_filepath"],
                    "synth_command": f"synth_xilinx -family {family}",
                    "log_filepath": output_filepaths["log_filepath"],
                    "extra_summary_fields": extra_summary_fields,
                },
            )
        ],
        "file_dep": [input_filepath],
        "targets": list(output_filepaths.values()),
    }

    if name is not None:
        task["name"] = name

    return (
        task,
        (
            output_filepaths["json_filepath"],
            output_filepaths["output_filepath"],
            output_filepaths["log_filepath"],
        ),
    )


def lattice_ecp5_diamond_synthesis(
    src_filepath: Union[Path, str],
    module_name: str,
    output_dirpath: Union[Path, str],
    json_filepath: Union[Path, str],
    extra_summary_fields: Dict[str, Any] = {},
):
    output_dirpath = Path(output_dirpath)
    output_dirpath.mkdir(parents=True, exist_ok=True)

    # Diamond's synthesis routine won't accept SystemVerilog, so we use sv2v to
    # convert. sv2v doesn't like Verilog 2001 attributes, so we remove them with
    # Yosys.
    sv2v_result_filepath = output_dirpath / f"{module_name}.v"
    # Make absolute. Resolves Diamond compilation issue of not finding the file
    # due to relative filepaths.
    sv2v_result_filepath = sv2v_result_filepath.resolve().absolute()
    subprocess.run(
        [
            "yosys",
            "-p",
            # We need proc, otherwise we get things like
            # always @ (posedge clk) r <= ...
            # always @ (posedge rst) r <= ...
            # Which is an error in most tools.
            f"read_verilog -sv {src_filepath}; proc; write_verilog -noattr {sv2v_result_filepath}",
        ],
        capture_output=True,
        check=True,
    )
    subprocess.run(
        ["sv2v", "-w", sv2v_result_filepath, sv2v_result_filepath],
        check=True,
    )

    assert (
        "DIAMOND_BINDIR" in os.environ
    ), "DIAMOND_BINDIR environment variable must be set to the directory containing Lattice Diamond binaries, e.g. /usr/local/diamond/3.12/bin/lin64"

    # Run synthesis. Set cwd to the output, as Diamond seems to output its
    # results to the cwd.
    env = os.environ.copy()
    env["bindir"] = os.environ["DIAMOND_BINDIR"]
    diamond_start = time()
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
    diamond_end = time()

    # Currently, Diamond will likely take issue with Calyx's designs when
    # running DRC. However, Diamond will still produce correct output. So we
    # ignore DRC errors.
    assert (
        out == 0 or out == 2
    ), f"Diamond failed with exit code {out}, indicating errors other than DRC errors."

    assert (
        output_dirpath / f"{module_name}_prim.v"
    ).exists(), "Diamond output file doesn't exist; Diamond probably failed."

    # Generate summary JSON.
    summary = count_resources_in_verilog_src(
        verilog_src=(output_dirpath / f"{module_name}_prim.v").read_text(),
        module_name=module_name,
    )

    summary["time_s"] = diamond_end - diamond_start

    for key in extra_summary_fields:
        assert key not in summary
        summary[key] = extra_summary_fields[key]

    json.dump(
        summary,
        fp=open(json_filepath, "w"),
    )


def collect(
    iteration: int,
    identifier: str,
    architecture: str,
    tool: str,
    json_filepath: Union[Path, str],
    collected_data_filepath: Union[Path, str],
):
    collected_data_filepath = Path(collected_data_filepath)

    with open(json_filepath, "r") as f:
        data = json.load(f)

    assert "iteration" not in data
    data["iteration"] = iteration

    if "identifier" in data:
        logging.warn(f"Overwriting identifier in {data} with {identifier}")
    data["identifier"] = identifier

    assert "architecture" not in data
    data["architecture"] = architecture

    assert "tool" not in data
    data["tool"] = tool

    collected_data_filepath.parent.mkdir(parents=True, exist_ok=True)
    with open(collected_data_filepath, "w") as f:
        json.dump(data, f)


def make_lattice_ecp5_diamond_synthesis_task(
    input_filepath: Union[str, Path],
    output_dirpath: Union[str, Path],
    module_name: str,
    clock_info: Optional[Tuple[str, float]] = None,
    name: Optional[str] = None,
    collect_args: Optional[Dict[str, Any]] = None,
    extra_summary_fields: Dict[str, Any] = {},
):
    """Wrapper over Diamond synthesis function which creates a DoIt task."""
    # TODO(@gussmith23): Support clocks on Lattice.
    if clock_info is not None:
        logging.warn("clock_info not supported for Lattice yet.")

    output_dirpath = Path(output_dirpath)
    input_filepath = Path(input_filepath)
    json_filepath = output_dirpath / f"{input_filepath.stem}_resource_utilization.json"

    task = {
        "actions": [
            (
                lattice_ecp5_diamond_synthesis,
                [input_filepath, module_name, output_dirpath],
                {
                    "json_filepath": json_filepath,
                    "extra_summary_fields": extra_summary_fields,
                },
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
            json_filepath,
        ],
    }

    if name is not None:
        task["name"] = name

    return (task, (json_filepath,))


def make_yosys_nextpnr_synthesis_task(
    input_filepath: Union[str, Path],
    output_dirpath: Union[str, Path],
    module_name: str,
):
    input_filepath = Path(input_filepath)
    output_dirpath = Path(output_dirpath)

    nextpnr_output_sv_filepath = output_dirpath / f"{module_name}_pnr.sv"
    synth_out_json = output_dirpath / f"{module_name}_synth.json"
    yosys_log_path = output_dirpath / f"{module_name}_yosys.log"
    nextpnr_log_path = output_dirpath / f"{module_name}_nextpnr.log"
    yosys_time_path = output_dirpath / f"{module_name}_yosys.time"
    nextpnr_time_path = output_dirpath / f"{module_name}_nextpnr.time"

    return {
        "actions": [
            (
                lattice_ecp5_yosys_nextpnr_synthesis,
                [
                    input_filepath,
                    module_name,
                    nextpnr_output_sv_filepath,
                    synth_out_json,
                    yosys_time_path,
                    nextpnr_time_path,
                    yosys_log_path,
                    nextpnr_log_path,
                ],
            )
        ],
        "targets": [
            nextpnr_output_sv_filepath,
            synth_out_json,
            yosys_log_path,
            nextpnr_log_path,
            yosys_time_path,
            nextpnr_time_path,
        ],
        "file_dep": [input_filepath],
    }


def make_intel_yosys_synthesis_task(
    input_filepath: Union[str, Path],
    output_dirpath: Union[str, Path],
    module_name: str,
    family: IntelFamily,
    name: Optional[str] = None,
    extra_summary_fields: Dict[str, Any] = {},
):
    output_dirpath = Path(output_dirpath)
    json_filepath = output_dirpath / f"{module_name}.json"
    output_filepath = output_dirpath / f"{module_name}.sv"
    log_filepath = output_dirpath / f"{module_name}.log"

    match family:
        case IntelFamily.CYCLONEV:
            synth_command = "synth_intel_alm -family cyclonev"
        case IntelFamily.CYCLONEIV:
            synth_command = "synth_intel -family cycloneiv"
        case IntelFamily.CYCLONE10LP:
            synth_command = "synth_intel -family cyclone10lp"
        case _:
            raise NotImplementedError(f"Family {family} not implemented.")

    task = {
        "actions": [
            (
                yosys_synthesis,
                [],
                {
                    "summary_filepath": json_filepath,
                    "input_filepath": input_filepath,
                    "module_name": module_name,
                    "output_filepath": output_filepath,
                    "synth_command": synth_command,
                    "log_filepath": log_filepath,
                    "extra_summary_fields": extra_summary_fields,
                },
            )
        ],
        "file_dep": [input_filepath],
        "targets": [
            json_filepath,
            output_filepath,
            log_filepath,
        ],
    }

    if name is not None:
        task["name"] = name

    return (task, (json_filepath, output_filepath, log_filepath))
