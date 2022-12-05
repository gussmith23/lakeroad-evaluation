"""DoIt main file.

The dodo.py file is like a Makefile for Python's DoIt library. Running `doit` in
a directory with a dodo.py file (or passing the -f <filepath> option to point to
a Python file) will run DoIt, loading the DoIt tasks starting from the dodo.py
file. It is the job of the dodo.py file to import all tasks to make them visible
to DoIt.
"""

from baseline_synthesis import task_baseline_synthesis
from calyx_tasks import *
from lakeroad import task_instruction_experiments
from gather_data import *
from yosys_experiments import *
from figures_and_tables import *
