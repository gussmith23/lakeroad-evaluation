#!/usr/bin/env python3
"""Template for new experiments.

Experiments should be designed to either be run standalone, or added as a
sub-experiment to a larger set of experiments.

To enable the experiment to be used as sub-experiments, implement your
experiment as a subclass of Experiment.

To enable standalone running, use an if __name__ == "__main__" section, as seen
at the bottom of this file. This section should parse arguments from the command
line, initialize the experiment, and run it.

"""

import os
from pathlib import Path
from experiment import Experiment


class ExperimentTemplate(Experiment):
    def __init__(self, value: int, output_dir=Path(os.getcwd())):
        """Constructor.

        Experiments should take an output_dir, which allows parent experiments
        to tell this experiment where to put its outputs.

        Experiments can be parameterized by taking other values in their
        constructor (e.g. `value`.)
        """

        # Set our output dir.
        super().__init__(output_dir=output_dir)
        # Could also do:
        # self._output_dir = output_dir

        self._value = value

    def _run_experiment(self):
        """Run the experiment!

        NOTE: you should most likely be overriding _run_experiment, not run()!

        Generally, this will do some kind of complex operation and write some
        output files."""
        self._output_dir.mkdir(exist_ok=True)

        # Computation...
        output = self._value

        with open(self._output_dir / "output.txt", "w") as f:
            print(f"Experiment run! Value: {output}", file=f)


# If the script is run standalone, this is what gets run!
if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument("--value", type=int)
    args = parser.parse_args()
    ExperimentTemplate(value=args.value).run()
