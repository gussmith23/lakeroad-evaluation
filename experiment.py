"""Definition of the Experiment class."""

from pathlib import Path
from typing import Union
import os


class Experiment(object):
    """Base class for experiments.

    Experiments are objects which can be run (via run(), or by calling directly).
    """

    def _run_experiment(self):
        """Run this experiment, but not its sub-experiments. run() is preferred.

        This function should implement your experiment logic. It should likely
        not be run directly, but instead be run via run()."""
        pass

    def __init__(self, output_dir: Union[str, Path] = Path(os.getcwd()), **kwargs):
        """Constructor.

        Any extra keyword arguments are collected in a config dictionary. These
        can be passed on to sub-experiments (though the user needs to make sure
        to pass in **self._config when constructing sub-experiments, which is a
        little clunky.)

        Args:
          output_dir: Results of this experiment (and its sub-experiments) will
          be written to this folder."""
        self._experiments = []
        self._output_dir = Path(output_dir)
        self._config = kwargs

    def run(self):
        """Run the experiment and all sub-experiments."""
        self._run_experiment()
        for sub_experiment in self._experiments:
            sub_experiment.run()

    def register(self, experiment):
        """Register a sub-experiment."""
        self._experiments.append(experiment)
