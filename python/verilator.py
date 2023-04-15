"""Utilities for simulating with Verilator."""

import io
import itertools
import logging
import os
from pathlib import Path
import random
import sys
from typing import List, Optional, Tuple, Union
import subprocess
import utils


def simulate_with_verilator(
    obj_dir_dir: Union[str, Path],
    test_module_filepath: List[Union[str, Path]],
    ground_truth_module_filepath: List[Union[str, Path]],
    module_inputs: List[Tuple[str, int]],
    clock_name: str,
    initiation_interval: int,
    testbench_cc_filepath: Union[str, Path],
    testbench_exe_filepath: Union[str, Path],
    testbench_inputs_filepath: Union[str, Path],
    makefile_filepath: Union[str, Path],
    output_signal: str,
    include_dirs: List[Union[str, Path]] = [],
    extra_args: List[str] = [],
):
    """

    Args:
      obj_dir_dir: Directory where we will store obj_dirs produced by Verilator.
      test_module_filepath: Filepath of Verilog file which serves as the module
        we're testing.
      ground_truth_module_filepath: Filepath of Verilog file which serves as the
        ground truth module.
      module_inputs: List of tuples of the form (input_name, input_width). We
        assume inputs are the same between the two modules.
      testbench_{c,exe}_output_filepath: Filepath to write the testbench
        code/executable to.
    """

    # Instantiate Makefile template for our code.
    if "VERILATOR_INCLUDE_DIR" not in os.environ:
        raise Exception(
            "VERILATOR_INCLUDE_DIR environment variable must be set to the "
            "directory where Verilator's include directory is located."
        )
    makefile_filepath = Path(makefile_filepath)
    makefile_filepath.write_text(
        (utils.lakeroad_evaluation_dir() / "misc" / "verilator_makefile.template")
        .read_text()
        .format(
            testbench_exe_filepath=testbench_exe_filepath,
            testbench_inputs_filepath=testbench_inputs_filepath,
            test_module_obj_dirpath=Path(obj_dir_dir) / "test_module",
            ground_truth_module_obj_dirpath=Path(obj_dir_dir) / "ground_truth_module",
            test_module_verilog_filepath=test_module_filepath,
            ground_truth_module_verilog_filepath=ground_truth_module_filepath,
            test_module_extra_verilator_args=" ".join(
                [f"-I{dir}" for dir in include_dirs] + extra_args
            ),
            ground_truth_module_extra_verilator_args=" ".join(
                [f"-I{dir}" for dir in include_dirs] + extra_args
            ),
            testbench_filepath=testbench_cc_filepath,
            verilator_include_dir=os.environ["VERILATOR_INCLUDE_DIR"],
        )
    )

    # Instantiate testbench template for our code.
    testbench_template_source = (
        utils.lakeroad_evaluation_dir() / "misc" / "verilator_testbench.cc.template"
    ).read_text()
    testbench_source = testbench_template_source.format(
        num_inputs=len(module_inputs),
        test_module_header_filepath=(
            Path(obj_dir_dir) / "test_module" / "Vtest_module.h"
        ),
        ground_truth_module_header_filepath=(
            Path(obj_dir_dir) / "ground_truth_module" / "Vground_truth_module.h"
        ),
        set_module_inputs_body=" ".join(
            [
                f"module->{name}=inputs[{i}];"
                for i, (name, _) in enumerate(module_inputs)
            ]
        ),
        set_module_clock_body=f"module->{clock_name}=clock;",
        initiation_interval=initiation_interval,
        output_signal=output_signal,
    )
    Path(testbench_cc_filepath).write_text(testbench_source)

    # Generate the input to the testbench.
    with testbench_inputs_filepath.open("w") as f:
        MAX_NUM_TESTS = 2**20
        if 2 ** (sum([width for _, width in module_inputs])) > MAX_NUM_TESTS:
            logging.warning(
                "Exhaustive testing space is too large, doing random testing."
            )
            # Generate a random subset of the inputs.
            def generate_one():
                return [random.randint(0, 2**width - 1) for _, width in module_inputs]

            all_inputs = [generate_one() for _ in range(MAX_NUM_TESTS)]
        else:
            # Do exhaustive testing.
            all_inputs = list(
                itertools.product(*[range(2**width) for _, width in module_inputs])
            )
        print(f"{len(module_inputs)} {len(all_inputs)}", file=f)
        for one_set_of_inputs in all_inputs:
            print(" ".join([str(x) for x in one_set_of_inputs]), file=f)

    try:
        subprocess.run(
            ["make", "--always-make", "-f", makefile_filepath],
            # You can easily debug if there's activity happening by commenting
            # out this line (though it may break the `except` block)
            capture_output=True,
            check=True,
        )
    except subprocess.CalledProcessError as e:
        print(e.stderr.decode("utf-8"), file=sys.stderr)
        raise e


def make_verilator_task(name: Optional[str] = None, **kwargs):
    """Make DoIt task for simulating with Verilator.

    See the args for `simulate_with_verilator` for the kwargs."""

    task = {}

    if name is not None:
        task["name"] = name

    task["actions"] = [(simulate_with_verilator, [], kwargs)]

    task["targets"] = [kwargs["obj_dir_dir"]]

    task["file_dep"] = [
        kwargs["test_module_filepath"],
        kwargs["ground_truth_module_filepath"],
    ]

    return task
