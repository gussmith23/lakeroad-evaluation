#!/usr/bin/env python3

from pathlib import Path
from typing import Union
from experiment import Experiment
import subprocess
import logging


class BaselineXilinxUltraScalePlusSynthesis(Experiment):
    """Xilinx UltraScale+ baseline.

    Synthesizes/places-and-routes baseline behavioral instruction
    implementations for Xilinx UltraScale+."""

    def __init__(
        self,
        output_dir: Union[str, Path],
        instructions_dir: Union[str, Path],
        overwrite_output_dir: bool = False,
    ) -> None:
        """Constructor.

        instructions_dir: the directory containing the instructions to be
        synthesized."""
        super().__init__()
        self._output_dir = Path(output_dir).resolve()
        self._instructions_dir = Path(instructions_dir).resolve()
        self._overwrite_output_dir = overwrite_output_dir

    def _run_experiment(self):
        self._output_dir.mkdir(parents=True, exist_ok=self._overwrite_output_dir)
        assert self._instructions_dir.exists(), "Directory of instructions not found."

        for instr_src_file in self._instructions_dir.glob("*"):
            module_name = instr_src_file.stem

            synth_out_sv = self._output_dir / f"{module_name}-synth-place-route.sv"

            # Create tcl script. TODO: could just check this in somewhere.
            tcl_file = self._output_dir / f"{module_name}.tcl"
            with open(tcl_file, "w") as f:
                f.write(
                    f"""
read_verilog -sv {instr_src_file}
synth_design
place_design
route_design
write_verilog {synth_out_sv}
              """
                )

            # Synthesis with Vivado.
            with open(self._output_dir / f"{module_name}.log", "w") as logfile:
                logging.info("Running Yosys synthesis on %s", instr_src_file)
                subprocess.run(
                    ["vivado", "-mode", "batch", "-source", tcl_file],
                    check=True,
                    stdout=logfile,
                    stderr=logfile,
                )


class BaselineLatticeECP5Synthesis(Experiment):
    """Synthesize instructions for Lattice ECP5 using the baseline tools."""

    def __init__(
        self,
        output_dir: Union[str, Path],
        instructions_dir: Union[str, Path],
        overwrite_output_dir: bool = False,
    ) -> None:
        """Constructor.

        instructions_dir: the directory containing the instructions to be
        synthesized."""
        super().__init__()
        self._output_dir = Path(output_dir).resolve()
        self._instructions_dir = Path(instructions_dir).resolve()
        self._overwrite_output_dir = overwrite_output_dir

    def _run_experiment(self):
        self._output_dir.mkdir(parents=True, exist_ok=self._overwrite_output_dir)
        assert self._instructions_dir.exists(), "Directory of instructions not found."

        for instr_src_file in self._instructions_dir.glob("*"):
            module_name = instr_src_file.stem

            synth_out_sv = self._output_dir / f"{module_name}-synth-ecp5.sv"
            synth_out_json = self._output_dir / f"{module_name}-synth-ecp5.json"

            # Synthesis with Yosys.
            with open(self._output_dir / f"{module_name}-yosys.log", "w") as logfile:
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
            with open(self._output_dir / f"{module_name}-nextpnr.log", "w") as logfile:
                logging.info("Running nextpnr place-and-route on %s", instr_src_file)
                subprocess.run(
                    ["nextpnr-ecp5", "--json", synth_out_json],
                    check=True,
                    stdout=logfile,
                    stderr=logfile,
                )


if __name__ == "__main__":
    import argparse
    import os

    logging.basicConfig(level=os.environ.get("LOGLEVEL", "WARNING"))

    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--output-dir",
        help="Output path for results.",
        required=True,
        type=Path,
    )
    parser.add_argument(
        "--overwrite-output-dir",
        help="Whether or not to overwrite the output dir, if it exists.",
        default=False,
        action=argparse.BooleanOptionalAction,
    )
    parser.add_argument(
        "--instructions-dir",
        help="Directory of instructions to synthesize.",
        required=True,
        type=Path,
    )
    parser.add_argument(
        "--lattice-ecp5",
        help="Whether to synthesize for Lattice ECP5.",
        default=True,
        action=argparse.BooleanOptionalAction,
    )
    parser.add_argument(
        "--xilinx-ultrascale-plus",
        help="Whether to synthesize for Xilinx UltraScale+.",
        default=True,
        action=argparse.BooleanOptionalAction,
    )
    args = parser.parse_args()

    if args.lattice_ecp5:
        BaselineLatticeECP5Synthesis(
            output_dir=args.output_dir / "lattice-ecp5",
            instructions_dir=args.instructions_dir,
            overwrite_output_dir=args.overwrite_output_dir,
        ).run()
    if args.xilinx_ultrascale_plus:
        BaselineXilinxUltraScalePlusSynthesis(
            output_dir=args.output_dir / "xilinx-ultrascale-plus",
            instructions_dir=args.instructions_dir,
            overwrite_output_dir=args.overwrite_output_dir,
        ).run()
