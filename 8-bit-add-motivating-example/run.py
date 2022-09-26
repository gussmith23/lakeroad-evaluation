#!/usr/bin/env python3
"""Motivating example: 8-bit add synthesized for Xilinx UltraScale+."""

import os
from pathlib import Path
from typing import Union
from experiment import Experiment
import subprocess
import logging


class MotivatingExample8BitAdd(Experiment):
    def __init__(self, output_dir: Path):
        super().__init__()
        self._output_dir = output_dir

    def run_vivado(self, filename: Union[str, Path]):
        logging.info("Running Vivado synthesis on %s", filename)
        filename = Path(filename).resolve()
        basename = filename.name
        output_file_base = self._output_dir / basename
        subprocess.run(
            [
                "vivado",
                "-mode",
                "batch",
                "-source",
                Path(__file__).parent.resolve() / "run.tcl",
                "-tclargs",
                filename,
                output_file_base,
            ],
            check=True,
        )

    def _run_experiment(self):
        self.run_vivado(Path(__file__).parent.resolve() / "manual-no-reg.v")
        self.run_vivado(Path(__file__).parent.resolve() / "behavioral-out-reg.v")
        self.run_vivado(Path(__file__).parent.resolve() / "behavioral-no-reg.v")


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument("--output-dir", required=True, type=Path)
    args = parser.parse_args()

    logging.basicConfig(
        level=os.environ.get("LOGLEVEL", "WARNING"),
    )

    MotivatingExample8BitAdd(**vars(args)).run()
