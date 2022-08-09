#!/usr/bin/env python3
"""Top-level experiment definition and run script.

Lakeroad's experiments (this one included) are all Python scripts that should be
able to be run directly from the command line, as well as being imported and run
programmatically."""

from pathlib import Path
from typing import Union
from experiment import Experiment
from generate_impls import GenerateImpls
from compile_instructions import InstructionSynthesis
import logging
import os


class LakeroadEvaluation(Experiment):
    """Top-level Experiment for the Lakeroad eval."""

    def __init__(
        self,
        instructions_dir: Union[str, Path],
        output_dir: Union[str, Path] = Path(os.getcwd()),
        overwrite_output_dir: bool = False,
        run_vivado: bool = True,
    ):
        """Constructor.

        Args:
          instructions_dir: Directory of baseline instruction implementations.
          output_dir: Where to write evaluation output files. All sub-experiment
            outputs will also end up in subdirectories of this directory.
          overwrite_output_dir: Whether or not to overwrite the output
            directory, if it already exists.
          run_vivado: Whether or not to attempt to run Vivado."""
        super().__init__()

        self._output_dir = Path(output_dir)
        self._overwrite_output_dir = overwrite_output_dir

        # Register sub-experiments.
        #
        # Note that we change the output directory to sub-folders of the current output
        # folder, in order to provide structure to the output files.
        #
        # Generate instruction impls.
        generate_impls_experiment = GenerateImpls(
            output_dir=output_dir / Path("instruction_impls")
        )
        self.register(generate_impls_experiment)
        # Baseline synthesis experiments. We disable the Xilinx UltraScale+
        # baseline if run_vivado is false.
        self.register(
            InstructionSynthesis(
                output_dir=output_dir / "instruction_synthesis",
                overwrite_output_dir=overwrite_output_dir,
                xilinx_ultrascale_plus_baseline_instructions_dir=Path(__file__)
                .resolve()
                .parent()
                / "instructions"
                / "src",
                xilinx_ultrascale_plus_lakeroad_instructions_dir=generate_impls_experiment.xilinx_ultrascale_plus_dir,
                lattice_ecp5_baseline_instructions_dir=Path(__file__).resolve().parent()
                / "instructions"
                / "src",
                lattice_ecp5_lakeroad_instructions_dir=generate_impls_experiment.lattice_ecp5_dir,
            )
        )

    def _run_experiment(self):
        # The top-level experiment doesn't do much, other than to create the
        # output directory and error if it already exists (if
        # overwrite_output_dir is False).
        self._output_dir.mkdir(parents=True, exist_ok=self._overwrite_output_dir)


if __name__ == "__main__":
    import argparse

    logging.basicConfig(level=os.environ.get("LOGLEVEL", "WARNING"))

    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--run-vivado",
        help="Whether or not to run the Vivado-based sections of the eval.",
        default=True,
        action=argparse.BooleanOptionalAction,
    )
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
        help="Directory of baseline instruction implementations.",
        required=True,
        type=Path,
    )
    args = parser.parse_args()

    # Construct and run the top-level experiment.
    LakeroadEvaluation(**vars(args)).run()
