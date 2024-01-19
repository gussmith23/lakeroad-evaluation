#!/bin/bash
# Runs the evaluation.
#
# Technically, the evaluation can be run simply by running `doit`, which will
# run all tasks associated with the evaluation. However, this is non-optimal, as
# each task requires a different amount of resources, and the evaluation run can
# be optimized by running groups of tasks with different numbers of threads.
#
# If the machine is too overloaded, we'll see odd failures, e.g. #116.
#
# The environment variables expected by this script are:
# - NUM_JOBS_LAKEROAD_TASKS: The number of parallel jobs to use for Lakeroad
#   tasks. Suggestion: (nproc - buffer) / 4
# - NUM_JOBS_OTHER_TASKS: The number of parallel jobs to use for all other
#   tasks. Suggestion: nproc - buffer
# "buffer" is a number of cores to leave free for the OS and other tasks. I
# suggest about 10% of cores.

if [[ -z "$NUM_JOBS_LAKEROAD_TASKS" ]]; then
    echo "Must provide NUM_JOBS_LAKEROAD_TASKS in environment" 1>&2
    exit 1
fi

if [[ -z "$NUM_JOBS_OTHER_TASKS" ]]; then
    echo "Must provide NUM_JOBS_OTHER_TASKS in environment" 1>&2
    exit 1
fi

doit --continue -n "$NUM_JOBS_LAKEROAD_TASKS" \
  'instruction_experiments:lakeroad_generate_*' \
  'robustness_experiments:*lakeroad-xilinx' \
  'robustness_experiments:*lattice-ecp5-lakeroad' \
  'robustness_experiments:*lakeroad_intel' \
  'robustness_experiments:*lakeroad-xilinx' \
  'robustness_experiments:*lattice-ecp5-lakeroad' \
  'robustness_experiments:*lakeroad_intel'
doit --continue -n "$NUM_JOBS_OTHER_TASKS"