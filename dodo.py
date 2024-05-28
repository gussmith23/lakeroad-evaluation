"""DoIt main file.

The dodo.py file is like a Makefile for Python's DoIt library. Running `doit` in
a directory with a dodo.py file (or passing the -f <filepath> option to point to
a Python file) will run DoIt, loading the DoIt tasks starting from the dodo.py
file. It is the job of the dodo.py file to import all tasks to make them visible
to DoIt.
"""

from robustness_experiments import *
from line_counts import *
from verin_experiments import *
