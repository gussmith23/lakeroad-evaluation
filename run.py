#!/usr/bin/env python3
"""Top-level experiment run script."""

import argparse
from pathlib import Path
from experiment import Experiment
from generate_impls import GenerateImpls
import logging 
import os

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

args.output_dir.mkdir(parents=True, exist_ok=args.overwrite_output_dir)

# The top-level experiment.
lakeroad_eval = Experiment(output_dir=args.output_dir)

# Demo: adding a sub-experiment. See the experiment template's definition for
# more information.
# import experiment_template
# lakeroad_eval.register(experiment_template.ExperimentTemplate(
#     23, output_dir=args.output_dir / "example_experiment_1"))
# lakeroad_eval.register(experiment_template.ExperimentTemplate(
#     42, output_dir=args.output_dir / "example_experiment_2"))
# lakeroad_eval.run()

# Register sub-experiments.
lakeroad_eval.register(GenerateImpls(output_dir=Path("instruction_impls")))

lakeroad_eval.run()