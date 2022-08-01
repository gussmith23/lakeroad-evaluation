"""Definition of the Experiment class."""


class Experiment(object):
    """Base class for experiments.

    Experiments are objects which can be run (via run(), or by calling directly).
    """

    def _run_experiment(self):
        """Run this experiment, but not its sub-experiments. run() is preferred.

        This function should implement your experiment logic. It should likely
        not be run directly, but instead be run via run()."""
        pass

    def __init__(self):
        self._experiments = []

    def run(self):
        """Run the experiment and all sub-experiments."""
        self._run_experiment()
        for sub_experiment in self._experiments:
            sub_experiment.run()

    def register(self, experiment):
        """Register a sub-experiment."""
        self._experiments.append(experiment)
