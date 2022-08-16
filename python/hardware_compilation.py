"""Utilities for running hardware compilation.

By hardware compilation, we mean hardware synthesis, placement, and routing
using "traditional" tools like Vivado, Yosys, and nextpnr."""
from pathlib import Path
from typing import Union
import subprocess
import os
import logging


def xilinx_ultrascale_plus_vivado_synthesis(
    instr_src_file: Union[str, Path],
    output_files_filename_base: Union[str, Path],
    module_name: str,
    log_path: Union[str, Path] = os.devnull,
):
    # Synthesis with Vivado.
    with open(log_path, "w") as logfile:
        logging.info("Running Vivado synthesis/place/route on %s", instr_src_file)
        subprocess.run(
            [
                "vivado",
                "-mode",
                "batch",
                "-source",
                Path(__file__).resolve().parent.parent
                / "tcl"
                / "synthesize_instruction_vivado.tcl",
                "-tclargs",
                instr_src_file,
                output_files_filename_base,
                module_name,
            ],
            check=True,
            stdout=logfile,
            stderr=logfile,
        )


def lattice_ecp5_yosys_nextpnr_synthesis(
    instr_src_file: Union[str, Path],
    output_files_filename_base: Union[str, Path],
    module_name: str,
    yosys_log_path: Union[str, Path] = os.devnull,
    nextpnr_log_path: Union[str, Path] = os.devnull,
):
    synth_out_sv = f"{output_files_filename_base}-synth-ecp5.sv"
    synth_out_json = f"{output_files_filename_base}-synth-ecp5.json"

    # Synthesis with Yosys.
    with open(yosys_log_path, "w") as logfile:
        logging.info("Running Yosys synthesis on %s", instr_src_file)
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

    # Place and route with nextpnr.
    # Runs in out-of-context mode, which doesn't insert I/O cells.
    with open(nextpnr_log_path, "w") as logfile:
        logging.info("Running nextpnr place-and-route on %s", instr_src_file)
        subprocess.run(
            ["nextpnr-ecp5", "--out-of-context", "--json", synth_out_json],
            check=True,
            stdout=logfile,
            stderr=logfile,
        )
