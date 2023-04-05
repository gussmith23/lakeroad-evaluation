"""Utilities for running hardware compilation.

By hardware compilation, we mean hardware synthesis, placement, and routing
using "traditional" tools like Vivado, Yosys, and nextpnr."""
import dataclasses
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
from typing import Dict, Optional, Tuple, Union
from tempfile import NamedTemporaryFile


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


@dataclass
class VivadoLogStats:
    """Statistics parsed from Vivado logfile.

    NOTE: it's important that this is not a nested dictionary, i.e. that all of
    the fields of this dictionary are strings/ints/floats and not lists/dicts.
    This is because each of these dictionaries becomes a row in a CSV file, and
    thus if there was a nested structure, it would get a lot more compilcated."""

    # Likely just the module name.
    identifier: str

    # The number of various resources used.
    clb_luts: int
    clb_regs: int
    carry8s: int
    f7muxes: int
    f8muxes: int
    f9muxes: int

    # Timing stats won't be present if there was not a clock constraint
    # provided, thus all timing stats are Optional.
    user_constraints_met: Optional[bool]
    worst_negative_slack: Optional[float]
    clock_name: Optional[str]
    clock_period_ns: Optional[float]
    clock_frequency_MHz: Optional[float]

    # CPU runtime of various Vivado commands as reported by Vivado, in seconds.
    synth_time: float
    # May or may not be present, as we may or may not run opt_design.
    opt_time: Optional[float]


def parse_ultrascale_log(log_text: str, identifier: str) -> VivadoLogStats:
    """Parse Vivado logs.

    Parses logs from Vivado version:
    Vivado v2021.2 (64-bit)
    SW Build 3367213 on Tue Oct 19 02:47:39 MDT 2021
    IP Build 3369179 on Thu Oct 21 08:25:16 MDT 2021"""
    ## Parse primitive table.
    # Get range to search between.
    matches = list(
        re.finditer(
            r"^9. Primitives$\r?\n^-------------$", log_text, flags=re.MULTILINE
        )
    )
    assert len(matches) == 1
    start_index = matches[0].span()[1]
    matches = list(
        re.finditer(
            r"^10. Black Boxes$\r?\n^---------------$", log_text, flags=re.MULTILINE
        )
    )
    end_index = matches[0].span()[0]
    # Find matches.
    matches = re.findall(
        r"^\| (\w+) +\| +(\d+) \| +\w+ \|$",
        log_text[start_index:end_index],
        flags=re.MULTILINE,
    )
    primitives = [(m[0], int(m[1])) for m in matches]

    ## CLB usage.
    matches = list(
        re.finditer(
            r"""
1\. CLB Logic
------------

\+-[+-]*
\| *Site Type *\| *Used *\| *Fixed *\| *Prohibited *\| *Available *\| *Util% *\|
\+-[+-]*
\| CLB LUTs +\| +(?P<clbluts>\d+) +\| +\d+ +\| +\d+ +\| +\d+ +\| +<?(?P<clblutsutil>\d+\.\d+) +\|
(^\|.*$\n?)*
\| CLB Registers +\| +(?P<clbregisters>\d+) +\| +\d+ +\| +\d+ +\| +\d+ +\| +<?(?P<clbregistersutil>\d+\.\d+) +\|
(^\|.*$\n?)*
\| CARRY8 +\| +(?P<carry8>\d+) +\| +\d+ +\| +\d+ +\| +\d+ +\| +<?(?P<carry8util>\d+\.\d+) +\|
\| F7 Muxes +\| +(?P<f7muxes>\d+) +\| +\d+ +\| +\d+ +\| +\d+ +\| +<?(?P<f7muxesutil>\d+\.\d+) +\|
\| F8 Muxes +\| +(?P<f8muxes>\d+) +\| +\d+ +\| +\d+ +\| +\d+ +\| +<?(?P<f8muxesutil>\d+\.\d+) +\|
\| F9 Muxes +\| +(?P<f9muxes>\d+) +\| +\d+ +\| +\d+ +\| +\d+ +\| +<?(?P<f9muxesutil>\d+\.\d+) +\|
\+-[+-]*""",
            log_text,
            flags=re.MULTILINE,
        )
    )
    assert len(matches) == 1
    m = matches[0]
    clb_luts = int(m["clbluts"])
    clb_regs = int(m["clbregisters"])
    carry8s = int(m["carry8"])
    f7muxes = int(m["f7muxes"])
    f8muxes = int(m["f8muxes"])
    f9muxes = int(m["f9muxes"])

    ## Timing.
    if re.search("There are no user specified timing constraints\.", log_text):
        user_constraints_met = None
        worst_negative_slack = None
        clock_name = None
        clock_period_ns = None
        clock_frequency_MHz = None
    else:
        ## Timing constraints met.
        user_constraints_met = bool(
            re.search(
                r"^All user specified timing constraints are met\.$",
                log_text,
                flags=re.MULTILINE,
            )
        )

        ## Timing summary.

        matches = re.findall(
            r"""\| Design Timing Summary
\| ---------------------
-+

^    WNS.*$
^[ -]+$
 +(-?\d+\.\d+|NA) """,
            log_text,
            flags=re.MULTILINE,
        )
        assert len(matches) == 1
        worst_negative_slack = None if matches[0] == "NA" else float(matches[0])

        matches = list(
            re.finditer(
                r"""-+
\| Clock Summary
\| -+
------------------------------------------------------------------------------------------------

Clock.*Waveform.*Period\(ns\).*Frequency\(MHz\).*
[ -]+
(?P<name>\w+) +{[\.\d ]+} +(?P<period>\d+\.\d+) +(?P<frequency>\d+\.\d+)""",
                log_text,
                flags=re.MULTILINE,
            )
        )
        assert len(matches) == 1
        clock_name = matches[0]["name"]
        clock_period_ns = float(matches[0]["period"])
        clock_frequency_MHz = float(matches[0]["frequency"])

    ## Parse latency of each command (synth_design, opt_design, etc)
    def _parse_command_latency(command: str) -> Optional[Tuple[float, float]]:
        """
        Returns a tuple of the CPU seconds and the elapsed seconds. Returns None
        if not found."""
        matches = list(
            re.finditer(
                rf"""{command} completed successfully
{command}: Time \(s\): cpu = (?P<cputime>.*) ; elapsed = (?P<elapsedtime>.*) . Memory \(MB\):""",
                log_text,
            )
        )

        if len(matches) == 0:
            return None

        assert len(matches) == 1

        def _get_secs(time_str: str):
            """Parse seconds from time string.

            Ignores elapsed time.

            Returns:
                cpu time in seconds."""
            parsed_datetime = datetime.strptime(time_str, "%H:%M:%S")
            converted_timedelta = timedelta(
                hours=parsed_datetime.hour,
                minutes=parsed_datetime.minute,
                seconds=parsed_datetime.second,
            )
            return converted_timedelta.total_seconds()

        return _get_secs(matches[0]["cputime"])

    synth_time = _parse_command_latency("synth_design")
    opt_time = _parse_command_latency("opt_design")

    return VivadoLogStats(
        clb_luts=clb_luts,
        clb_regs=clb_regs,
        carry8s=carry8s,
        f7muxes=f7muxes,
        f8muxes=f8muxes,
        f9muxes=f9muxes,
        user_constraints_met=user_constraints_met,
        worst_negative_slack=worst_negative_slack,
        clock_name=clock_name,
        clock_period_ns=clock_period_ns,
        clock_frequency_MHz=clock_frequency_MHz,
        synth_time=synth_time,
        opt_time=opt_time,
        identifier=identifier,
    )


def xilinx_ultrascale_plus_vivado_synthesis(
    instr_src_file: Union[str, Path],
    synth_opt_place_route_output_filepath: Union[str, Path],
    module_name: str,
    time_filepath: Union[str, Path],
    tcl_script_filepath: Union[str, Path],
    log_path: Union[str, Path],
    json_filepath: Union[str, Path],
    directive: str = "default",
    synth_design: bool = True,
    opt_design: bool = True,
    synth_design_rtl_flags: bool = False,
    clock_info: Optional[Tuple[str, float]] = None,
    fail_if_constraints_not_met=True,
    place_directive: str = "default",
    route_directive: str = "default",
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
        json_filepath: Filepath of the output JSON file where results parsed
          from the Vivado logfile should be written.
        clock_info: Clock name and period in nanoseconds. When provided, a
          constraint file will be created and loaded using the given clock
          information.
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
            clock_name, clock_period = clock_info
            # We use 7 because that's what the Calyx team used for their eval.
            # We could try to refine the clock period per design. Rachit's notes:
            #
            set_clock_command = f"create_clock -period {clock_period} -name {clock_name} -waveform {{0.0 1}} [get_ports {clock_name}]"
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
set_part xczu3eg-sbva484-1-e

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

    # Synthesis with Vivado.
    with open(log_path, "w") as logfile:
        logging.info("Running Vivado synthesis/place/route on %s", instr_src_file)

        # Setting this environment variable prevents an error when running
        # Vivado route_design inside a Docker container. See:
        # https://community.flexera.com/t5/InstallAnywhere-Forum/Issues-when-running-Xilinx-tools-or-Other-vendor-tools-in-docker/m-p/245820#M10647
        env = os.environ.copy()
        ld_preload_previous_value = env["LD_PRELOAD"] if "LD_PRELOAD" in env else ""
        env[
            "LD_PRELOAD"
        ] = f"/lib/x86_64-linux-gnu/libudev.so.1:{ld_preload_previous_value}"

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
            env=env,
        )
        end_time = time()

    with open(time_filepath, "w") as f:
        print(f"{end_time-start_time}s", file=f)

    with open(json_filepath, "w") as f:
        log_stats = parse_ultrascale_log(open(log_path).read(), identifier=module_name)
        json.dump(dataclasses.asdict(log_stats), f)
        if fail_if_constraints_not_met:
            assert (
                log_stats.user_constraints_met is None
                or log_stats.user_constraints_met is True
            ), "Vivado reports that user constraints were not met!"


def make_xilinx_ultrascale_plus_vivado_synthesis_task_opt(
    input_filepath: Union[str, Path],
    output_dirpath: Union[str, Path],
    module_name: str,
    clock_info: Optional[Tuple[str, float]] = None,
):
    """Wrapper over Vivado synthesis function which creates a DoIt task.

    This task will run Vivado with optimizations."""

    input_filepath = Path(input_filepath)
    output_dirpath = Path(output_dirpath)
    synth_opt_place_route_output_filepath = output_dirpath / input_filepath.name
    time_filepath = output_dirpath / f"{input_filepath.stem}.time"
    log_filepath = output_dirpath / f"{input_filepath.stem}.log"
    tcl_script_filepath = output_dirpath / f"{input_filepath.stem}.tcl"
    json_filepath = output_dirpath / f"{input_filepath.stem}.json"

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
                    "clock_info": clock_info,
                    "synth_design": True,
                    "json_filepath": json_filepath,
                },
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


def make_xilinx_ultrascale_plus_vivado_synthesis_task_noopt(
    input_filepath: Union[str, Path],
    output_dirpath: Union[str, Path],
    module_name: str,
    clock_info: Optional[Tuple[str, float]] = None,
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
                    "directive": "RuntimeOptimized",
                    "place_directive": "RuntimeOptimized",
                    "route_directive": "RuntimeOptimized",
                    "opt_design": False,
                    "synth_design": True,
                    "synth_design_rtl_flags": False,
                    "clock_info": clock_info,
                    "json_filepath": json_filepath,
                },
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
    time_filepath: Union[str, Path],
    synth_command: str,
    log_filepath: Union[str, Path],
    json_filepath: Union[str, Path],
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
            print(f"Error log in {(str(logfile))}", file=sys.stderr)
            raise e

    with open(time_filepath, "w") as f:
        print(f"{yosys_end_time-yosys_start_time}s", file=f)

    # We don't need to PnR with nextpnr anymore. All Lakeroad instructions are
    # validated through PnR with Vivado/Diamond. And we only need synthesis (not
    # pnr) results for baseline.
    # # Place and route with nextpnr.
    # # Runs in out-of-context mode, which doesn't insert I/O cells.
    # with open(nextpnr_log_path, "w") as logfile:
    #     logging.info("Running nextpnr place-and-route on %s", instr_src_file)
    #     try:
    #         nextpnr_start_time = time()
    #         subprocess.run(
    #             ["nextpnr-ecp5", "--out-of-context", "--json", synth_out_json],
    #             check=True,
    #             stdout=logfile,
    #             stderr=logfile,
    #         )
    #         nextpnr_end_time = time()
    #     except subprocess.CalledProcessError as e:
    #         print(f"Error log in {(str(logfile))}", file=sys.stderr)
    #         raise e

    # with open(nextpnr_time_path, "w") as f:
    #     print(f"{nextpnr_end_time-nextpnr_start_time}s", file=f)

    parsed = parse_yosys_log(open(log_filepath).read())
    parsed["yosys_runtime_s"] = yosys_end_time - yosys_start_time
    parsed["identifier"] = module_name
    with open(json_filepath, "w") as f:
        json.dump(parsed, f)


def make_lattice_ecp5_yosys_synthesis_task(
    input_filepath: Union[str, Path],
    output_dirpath: Union[str, Path],
    module_name: str,
    clock_info: Optional[Tuple[str, float]] = None,
):
    """Wrapper over Yosys synthesis function which creates a DoIt task."""
    # TODO(@gussmith23): Support clocks on Lattice.
    if clock_info is not None:
        logging.warn("clock_info not supported for Lattice yet.")

    output_dirpath = Path(output_dirpath)
    json_filepath = output_dirpath / f"{module_name}.json"
    output_filepath = output_dirpath / f"{module_name}.sv"
    time_filepath = output_dirpath / f"{module_name}.time"
    log_filepath = output_dirpath / f"{module_name}.log"

    return {
        "actions": [
            (
                yosys_synthesis,
                [],
                {
                    "json_filepath": json_filepath,
                    "input_filepath": input_filepath,
                    "module_name": module_name,
                    "output_filepath": output_filepath,
                    "time_filepath": time_filepath,
                    "synth_command": "synth_ecp5",
                    "log_filepath": log_filepath,
                },
            )
        ],
        "file_dep": [input_filepath],
        "targets": [json_filepath, output_filepath, time_filepath, log_filepath],
    }


def make_xilinx_ultrascale_plus_yosys_synthesis_task(
    input_filepath: Union[str, Path],
    output_dirpath: Union[str, Path],
    module_name: str,
    clock_info: Optional[Tuple[str, float]] = None,
    name: Optional[str] = None,
):
    """Wrapper over Yosys synthesis function which creates a DoIt task."""
    # TODO(@gussmith23): Support clocks on Lattice.
    if clock_info is not None:
        logging.warn("clock_info not supported for Yosys.")

    output_dirpath = Path(output_dirpath)
    json_filepath = output_dirpath / f"{module_name}.json"
    output_filepath = output_dirpath / f"{module_name}.sv"
    time_filepath = output_dirpath / f"{module_name}.time"
    log_filepath = output_dirpath / f"{module_name}.log"

    task = {
        "actions": [
            (
                yosys_synthesis,
                [],
                {
                    "json_filepath": json_filepath,
                    "input_filepath": input_filepath,
                    "module_name": module_name,
                    "output_filepath": output_filepath,
                    "time_filepath": time_filepath,
                    "synth_command": "synth_xilinx -family xcup",
                    "log_filepath": log_filepath,
                },
            )
        ],
        "file_dep": [input_filepath],
        "targets": [json_filepath, output_filepath, time_filepath, log_filepath],
    }

    if name is not None:
        task["name"] = name

    return task


def lattice_ecp5_diamond_synthesis(
    src_filepath: Union[Path, str],
    module_name: str,
    output_dirpath: Union[Path, str],
    json_filepath: Union[Path, str],
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

    with open(json_filepath, "w") as f:
        log_stats = parse_diamond_log(
            open(Path(output_dirpath) / "synthesis.log").read(), identifier=module_name
        )
        json.dump(dataclasses.asdict(log_stats), f)


def make_lattice_ecp5_diamond_synthesis_task(
    input_filepath: Union[str, Path],
    output_dirpath: Union[str, Path],
    module_name: str,
    clock_info: Optional[Tuple[str, float]] = None,
):
    """Wrapper over Diamond synthesis function which creates a DoIt task."""
    # TODO(@gussmith23): Support clocks on Lattice.
    if clock_info is not None:
        logging.warn("clock_info not supported for Lattice yet.")

    output_dirpath = Path(output_dirpath)
    json_filepath = output_dirpath / f"{input_filepath.stem}.json"

    return {
        "actions": [
            (
                lattice_ecp5_diamond_synthesis,
                [input_filepath, module_name, output_dirpath],
                {"json_filepath": json_filepath},
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
