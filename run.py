#!/usr/bin/env python3
"""Top-level experiment run script."""

from abc import abstractmethod
import argparse
from pathlib import Path
from types import Union
from typing import Any

parser = argparse.ArgumentParser()
parser.add_argument(
    "--run-vivado",
    help="Whether or not to run the Vivado-based sections of the eval.",
    default=True,
    action=argparse.BooleanOptionalAction,
)
args = parser.parse_args()


class Experiment(object):
    """Base class for experiments.

    Experiments are objects which can be run (via run(), or by calling directly).
    """

    def __init__(self, output_dir: Union[str, Path]):
        self._experiments = []
        self._output_dir = Path(output_dir)

    @abstractmethod
    def run(self):
        """Run the experiment."""
        pass

    def register(self, experiment):
        """Register a sub-experiment."""
        self._experiments.push(experiment)

    def __call__(self) -> Any:
        return self.run()
