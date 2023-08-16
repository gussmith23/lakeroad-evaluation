"""Utilities for simulating with Verilator."""

import itertools
import logging
import os
from pathlib import Path
import random
import sys
from typing import List, Optional, Tuple, Union
import subprocess
import utils

# Imported from lakeroad/bin, which must be on the PYTHONPATH.
from simulate_with_verilator import simulate_with_verilator


def make_verilator_task(
    output_dirpath: Union[Path, str],
    test_module_filepath: List[Union[str, Path]],
    ground_truth_module_filepath: List[Union[str, Path]],
    module_inputs: List[Tuple[str, int]],
    clock_name: str,
    initiation_interval: int,
    output_signal: str,
    max_num_tests: int,
    include_dirs: List[Union[str, Path]] = [],
    extra_args: List[str] = [],
    ignore_missing_test_module_file: bool = False,
    name: Optional[str] = None,
    alternative_file_dep: Optional[Union[Path, str]] = None,
):
    """Make DoIt task for simulating with Verilator.

    See the args for `simulate_with_verilator` for the kwargs.

    Args:
      alternative_file_dep: A stand-in for the target Verilog, which may or may
        not exist if the tool fails. A good example: the JSON file that Lakeroad
        produces.
    """

    task = {}

    if name is not None:
        task["name"] = name

    output_dirpath = Path(output_dirpath)

    output_filepaths = {
        "obj_dir_dir": output_dirpath / "verilator_obj_dir",
        "testbench_exe_filepath": output_dirpath / "testbench",
        "testbench_stdout_log_filepath": output_dirpath / "testbench_stdout.log",
        "testbench_stderr_log_filepath": output_dirpath / "testbench_stderr.log",
        "makefile_filepath": output_dirpath / "Makefile",
        "testbench_inputs_filepath": output_dirpath / "testbench_inputs.txt",
        "testbench_cc_filepath": output_dirpath / "testbench.cc",
    }

    task["actions"] = [
        (
            simulate_with_verilator,
            [],
            {
                "obj_dir_dir": output_filepaths["obj_dir_dir"],
                "testbench_exe_filepath": output_filepaths["testbench_exe_filepath"],
                "testbench_stdout_log_filepath": output_filepaths[
                    "testbench_stdout_log_filepath"
                ],
                "testbench_stderr_log_filepath": output_filepaths[
                    "testbench_stderr_log_filepath"
                ],
                "makefile_filepath": output_filepaths["makefile_filepath"],
                "testbench_inputs_filepath": output_filepaths[
                    "testbench_inputs_filepath"
                ],
                "testbench_cc_filepath": output_filepaths["testbench_cc_filepath"],
                "test_module_filepath": test_module_filepath,
                "ground_truth_module_filepath": ground_truth_module_filepath,
                "module_inputs": module_inputs,
                "clock_name": clock_name,
                "initiation_interval": initiation_interval,
                "output_signal": output_signal,
                "include_dirs": include_dirs,
                "extra_args": extra_args,
                "max_num_tests": max_num_tests,
                "ignore_missing_test_module_file": ignore_missing_test_module_file,
            },
        )
    ]

    task["targets"] = list(output_filepaths.values())

    task["file_dep"] = [
        ground_truth_module_filepath,
    ]

    if alternative_file_dep is not None:
        task["file_dep"].append(alternative_file_dep)
    else:
        task["file_dep"].append(test_module_filepath)

    return (task,)
