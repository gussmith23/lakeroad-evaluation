#!/usr/bin/env python3
"""Top-level experiment definition and run script.

Lakeroad's experiments (this one included) are all Python scripts that should be
able to be run directly from the command line, as well as being imported and run
programmatically."""

from pathlib import Path
from typing import Optional, Union
from experiment import Experiment
from experiments.generate_impls import GenerateImpls
from experiments.compile_instructions import InstructionSynthesis
from experiments.calyx_end_to_end import CalyxEndToEnd
from experiments.run_calyx_tests import RunCalyxTests
import logging
import os


class LakeroadEvaluation(Experiment):
    """Top-level Experiment for the Lakeroad eval."""

    def __init__(
        self,
        instructions_dir: Union[str, Path],
        output_dir: Union[str, Path] = Path(os.getcwd()),
        vanilla_calyx_dir: Optional[Union[str, Path]] = None,
        vanilla_fud_path: Optional[Union[str, Path]] = None,
        xilinx_ultrascale_plus_calyx_dir: Optional[Union[str, Path]] = None,
        xilinx_ultrascale_plus_fud_path: Optional[Union[str, Path]] = None,
        lattice_ecp5_calyx_dir: Optional[Union[str, Path]] = None,
        lattice_ecp5_fud_path: Optional[Union[str, Path]] = None,
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
                xilinx_ultrascale_plus_baseline_instructions_dir=instructions_dir,
                xilinx_ultrascale_plus_lakeroad_instructions_dir=generate_impls_experiment.xilinx_ultrascale_plus_dir,
                lattice_ecp5_baseline_instructions_dir=instructions_dir,
                lattice_ecp5_lakeroad_instructions_dir=generate_impls_experiment.lattice_ecp5_dir,
                run_vivado=run_vivado,
            )
        )

        # Run Calyx tests with Lakeroad-generated instruction implementations.
        RunCalyxTests(
            lattice_ecp5_calyx_dir=lattice_ecp5_calyx_dir,
            lattice_ecp5_impls_dir=generate_impls_experiment.lattice_ecp5_dir,
            xilinx_ultrascale_plus_calyx_dir=xilinx_ultrascale_plus_calyx_dir,
            xilinx_ultrascale_plus_impls_dir=generate_impls_experiment.xilinx_ultrascale_plus_dir,
        )

        # Calyx "end-to-end" experiments: use Lakeroad-generated instructions in
        # Calyx to compile .futil files found in Calyx, run hardware synthesis
        # on the results.
        CalyxEndToEnd(
            output_dir=output_dir / "calyx_end_to_end",
            vanilla_calyx_dir=vanilla_calyx_dir,
            vanilla_fud_path=vanilla_fud_path,
            xilinx_ultrascale_plus_calyx_dir=xilinx_ultrascale_plus_calyx_dir,
            xilinx_ultrascale_plus_fud_path=xilinx_ultrascale_plus_fud_path,
            lattice_ecp5_calyx_dir=lattice_ecp5_calyx_dir,
            lattice_ecp5_fud_path=lattice_ecp5_fud_path,
            overwrite_output_dir=overwrite_output_dir,
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
    parser.add_argument(
        "--vanilla-calyx-dir",
        help='Directory of "vanilla", i.e. unmodified, Calyx.',
        required=False,
        type=Path,
    )
    parser.add_argument(
        "--vanilla-fud-path",
        help="Path to vanilla fud binary",
        required=False,
        type=Path,
    )
    parser.add_argument(
        "--xilinx-ultrascale-plus-calyx-dir",
        help="Directory of the Xilinx UltraScale+ Calyx instance.",
        required=False,
        type=Path,
    )
    parser.add_argument(
        "--xilinx-ultrascale-plus-fud-path",
        help="Path to Xilinx UltraScale+ Calyx instance's fud binary",
        required=False,
        type=Path,
    )
    parser.add_argument(
        "--lattice-ecp5-calyx-dir",
        help="Directory of the Lattice ECP5 Calyx instance.",
        required=False,
        type=Path,
    )
    parser.add_argument(
        "--lattice-ecp5-fud-path",
        help="Path to Lattice ECP5 Calyx instance's fud binary",
        required=False,
        type=Path,
    )
    args = parser.parse_args()

    # Construct and run the top-level experiment.
    LakeroadEvaluation(**vars(args)).run()
