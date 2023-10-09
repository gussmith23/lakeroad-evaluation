"""Utilities for simulating with Verilator."""

import os
from pathlib import Path
from typing import List, Optional, Tuple, Union

# Imported from lakeroad/bin, which must be on the PYTHONPATH.
from simulate_with_verilator import simulate_with_verilator


def make_verilator_task(
    output_dirpath: Union[Path, str],
    test_module_filepath: List[Union[str, Path]],
    ground_truth_module_filepath: List[Union[str, Path]],
    test_module_name: str,
    ground_truth_module_name: str,
    module_inputs: List[Tuple[str, int]],
    clock_name: str,
    initiation_interval: int,
    module_outputs: List[Tuple[str, int]],
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
        "obj_dir_dirpath": output_dirpath / "verilator_obj_dir",
        "testbench_exe_filepath": output_dirpath / "testbench",
        "testbench_stdout_log_filepath": output_dirpath / "testbench_stdout.log",
        "testbench_stderr_log_filepath": output_dirpath / "testbench_stderr.log",
        "makefile_filepath": output_dirpath / "Makefile",
        "testbench_inputs_filepath": output_dirpath / "testbench_inputs.txt",
        "testbench_sv_filepath": output_dirpath / "testbench.sv",
    }

    task["actions"] = [
        (
            simulate_with_verilator,
            [],
            {
                "obj_dirpath": output_filepaths["obj_dir_dirpath"],
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
                "testbench_sv_filepath": output_filepaths["testbench_sv_filepath"],
                "verilog_filepaths": [
                    test_module_filepath,
                    ground_truth_module_filepath,
                ],
                "module_inputs": module_inputs,
                "clock_name": clock_name,
                "initiation_interval": initiation_interval,
                "module_outputs": module_outputs,
                "include_dirs": include_dirs,
                "extra_args": extra_args,
                "max_num_tests": max_num_tests,
                "ignore_missing_test_module_file": ignore_missing_test_module_file,
                "expect_all_zero_outputs": False,
                "test_module_name": test_module_name,
                "ground_truth_module_name": ground_truth_module_name,
                # Allows us to override the C++ compiler. It would be nice if
                # the Verilator Makefile read the CXX variable directly; I
                # requested this functionality in
                # https://github.com/verilator/verilator/issues/4549.
                "extra_make_args": (
                    [f"CXX={os.environ['CXX']}"] if "CXX" in os.environ else []
                ),
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
