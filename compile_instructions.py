#!/usr/bin/env python3
"""Compile (i.e. run hardware synthesis on) instruction implementations.

In this sub-experiment, we compile (hardware synthesis, placement, routing)
instructions, both the behavioral Verilog baseline implementations and the
implementations generated by our tool.
"""

from pathlib import Path
from typing import Optional, Union
from experiment import Experiment
import subprocess
import logging
import os


class InstructionSynthesis(Experiment):
    """Run hardware synthesis/placement/routing on instructions."""

    def __init__(
        self,
        output_dir: Union[str, Path],
        overwrite_output_dir: bool = False,
        xilinx_ultrascale_plus_baseline_instructions_dir: Optional[
            Union[str, Path]
        ] = None,
        xilinx_ultrascale_plus_lakeroad_instructions_dir: Optional[
            Union[str, Path]
        ] = None,
        lattice_ecp5_baseline_instructions_dir: Optional[Union[str, Path]] = None,
        lattice_ecp5_lakeroad_instructions_dir: Optional[Union[str, Path]] = None,
        run_vivado: bool = True,
    ) -> None:
        """Constructor.

        lattice_ecp5/xilinx_ultrascale_plus: whether to run the various sub-experiments.
        """
        super().__init__()

        self._output_dir = output_dir
        self._overwrite_output_dir = overwrite_output_dir

        # Register sub-experiments
        if lattice_ecp5_baseline_instructions_dir:
            self.register(
                LatticeECP5Synthesis(
                    output_dir=output_dir / "lattice_ecp5_baseline",
                    instructions_dir=lattice_ecp5_baseline_instructions_dir,
                    overwrite_output_dir=overwrite_output_dir,
                )
            )
        if lattice_ecp5_lakeroad_instructions_dir:
            self.register(
                LatticeECP5Synthesis(
                    output_dir=output_dir / "lattice_ecp5_lakeroad",
                    instructions_dir=lattice_ecp5_lakeroad_instructions_dir,
                    overwrite_output_dir=overwrite_output_dir,
                )
            )
        if run_vivado:
            if xilinx_ultrascale_plus_baseline_instructions_dir:
                self.register(
                    XilinxUltraScalePlusSynthesis(
                        output_dir=output_dir / "xilinx_ultrascale_plus_baseline",
                        instructions_dir=xilinx_ultrascale_plus_baseline_instructions_dir,
                        overwrite_output_dir=overwrite_output_dir,
                    )
                )
            if xilinx_ultrascale_plus_lakeroad_instructions_dir:
                self.register(
                    XilinxUltraScalePlusSynthesis(
                        output_dir=output_dir / "xilinx_ultrascale_plus_lakeroad",
                        instructions_dir=xilinx_ultrascale_plus_lakeroad_instructions_dir,
                        overwrite_output_dir=overwrite_output_dir,
                    )
                )

    def _run_experiment(self):
        self._output_dir.mkdir(parents=True, exist_ok=self._overwrite_output_dir)


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
                Path(__file__).resolve().parent() / "synthesize_instruction_vivado.tcl",
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
    with open(nextpnr_log_path, "w") as logfile:
        logging.info("Running nextpnr place-and-route on %s", instr_src_file)
        subprocess.run(
            ["nextpnr-ecp5", "--json", synth_out_json],
            check=True,
            stdout=logfile,
            stderr=logfile,
        )


class XilinxUltraScalePlusSynthesis(Experiment):
    """Xilinx UltraScale+ hardware synthesis.

    Synthesizes/places-and-routes instructions for UltraScale+ using Vivado."""

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
            out_file_base = self._output_dir / module_name
            xilinx_ultrascale_plus_vivado_synthesis(
                instr_src_file=instr_src_file,
                output_files_filename_base=out_file_base,
                module_name=module_name,
                log_path=self._output_dir / f"{module_name}_vivado.log",
            )


class LatticeECP5Synthesis(Experiment):
    """Synthesize instructions for Lattice ECP5."""

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
            lattice_ecp5_yosys_nextpnr_synthesis(
                instr_src_file=instr_src_file,
                output_files_filename_base=self._output_dir / module_name,
                module_name=module_name,
                yosys_log_path=self._output_dir / f"{module_name}-yosys.log",
                nextpnr_log_path=self._output_dir / f"{module_name}-nextpnr.log",
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
    parser.add_argument(
        "--xilinx-ultrascale-plus-baseline-instructions-dir",
        help="Directory of UltraScale+ baseline implementations.",
        nargs="?",
        type=Path,
    )
    parser.add_argument(
        "--xilinx-ultrascale-plus-lakeroad-instructions-dir",
        help="Directory of UltraScale+ implementations generated by Lakeroad.",
        nargs="?",
        type=Path,
    )
    parser.add_argument(
        "--lattice-ecp5-baseline-instructions-dir",
        help="Directory of Lattice ECP5 baseline implementations.",
        nargs="?",
        type=Path,
    )
    parser.add_argument(
        "--lattice-ecp5-lakeroad-instructions-dir",
        help="Directory of Lattice ECP5 implementations generated by Lakeroad.",
        nargs="?",
        type=Path,
    )
    args = parser.parse_args()

    InstructionSynthesis(**vars(args)).run()