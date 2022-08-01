#!/usr/bin/env python3
"""Top-level experiment definition and run script.

Lakeroad's experiments (this one included) are all Python scripts that should be
able to be run directly from the command line, as well as being imported and run
programmatically."""

from pathlib import Path
from typing import Union
from experiment import Experiment
from generate_impls import GenerateImpls
import logging
import os


class LakeroadEvaluation(Experiment):
    """Top-level Experiment for the Lakeroad eval."""

    def __init__(
        self,
        output_dir: Union[str, Path] = Path(os.getcwd()),
        overwrite_output_dir: bool = False,
        **kwargs
    ):
        super().__init__()

        self._output_dir = Path(output_dir)
        self._overwrite_output_dir = overwrite_output_dir

        # Register sub-experiments.
        #
        # Note that we change the output directory to sub-folders of the current output
        # folder, in order to provide structure to the output files.
        self.register(GenerateImpls(output_dir=output_dir / Path("instruction_impls")))

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
    args = parser.parse_args()

    # Construct and run the top-level experiment.
    LakeroadEvaluation(**vars(args)).run()
