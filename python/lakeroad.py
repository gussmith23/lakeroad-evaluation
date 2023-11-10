"""Defines Lakeroad instruction synthesis tasks."""

import logging
import subprocess
from pathlib import Path
from time import time
from typing import List, Union

import doit
import pandas as pd
import utils
import yaml
from hardware_compilation import *
from schema import *

# These are defined in Lakeroad's main.rkt file.
TIMEOUT_RETURN_CODE = 26
SYNTHESIS_FAIL_RETURN_CODE = 25
SYNTHESIS_SUCCESS_RETURN_CODE = 0


def invoke_lakeroad(
    module_name: str,
    # TODO(@gussmith23): Give this a default value of None. Will break
    # positional uses.
    instruction: Optional[str],
    template: str,
    out_filepath: Union[str, Path],
    architecture: str,
    json_filepath: Union[str, Path],
    verilog_module_filepath: Optional[Union[str, Path]] = None,
    top_module_name: Optional[str] = None,
    verilog_module_out_signal: Optional[Tuple[str, int]] = None,
    initiation_interval: Optional[int] = None,
    inputs: Optional[List[Tuple[str, int]]] = None,
    clock_name: Optional[str] = None,
    reset_name: Optional[str] = None,
    timeout: Optional[int] = None,
    check_returncode: bool = False,
    extra_summary_fields: Dict[str, Any] = {},
    stderr_filepath: Optional[Union[str, Path]] = None,
    extra_cycles: Optional[int] = None,
):
    """Invoke Lakeroad to generate an instruction implementation.

    The arguments to this function mostly mirror the arguments to the
    bin/main.rkt file in Lakeroad.

    Args:
      instruction: The Racket code representing the instruction. See main.rkt.
        This argument is optional; the input to Lakeroad can also be specified
        as a Verilog file in verilog_module_filepath.
      json_filepath: After this function generates the Lakeroad implementation,
        it collects information from the implementation (which later is used to
        make the tables in the paper). This is the path to write the collected
        data (in JSON format) to.
      verilog_module_filepath: The input Verilog file to compile.
      top_module_name: The name of the module to compile in the Verilog file.
      verilog_module_out_signal: The name of the output signal of the top
        module.
      inputs: Inputs to the Verilog module. Must be specified for sequential
        synthesis. A list of tuples, (<name>, <bitwidth>).
      initiation_interval: The initiation interval of the module, for sequential
        synthesis.
      timeout: Timeout arg to pass to Lakeroad (in seconds).
      check_returncode: Whether or not to run check_returncode(). Defaults to
        False.
      extra_summary_fields: Extra fields to write into the final JSON summary.

    TODO Could also allow users to specify whether Lakeroad should fail. E.g.
    addition isn't implemented on SOFA, so we could allow users to attempt to
    invoke Lakeroad to generate a SOFA add and expect the subprocess to
    terminate with an error code."""
    out_filepath = Path(out_filepath)

    out_filepath.parent.mkdir(parents=True, exist_ok=True)

    lakeroad_invoke = (
        [
            str(
                utils.lakeroad_evaluation_dir()
                / "lakeroad"
                / "bin"
                / "lakeroad-portfolio.py"
            ),
        ]
        if True
        else [
            "raco",
            "symtrace",
            "--racket",
            str(utils.lakeroad_evaluation_dir() / "lakeroad" / "bin" / "main.rkt"),
            "--",
        ]
    )
    cmd = lakeroad_invoke + [
        "--out-format",
        "verilog",
        "--template",
        template,
        "--module-name",
        module_name,
        "--out-filepath",
        out_filepath,
        "--architecture",
        architecture,
    ]

    if instruction != None and verilog_module_filepath == None:
        # If instruction is specified and an input Verilog file isn't.
        cmd += [
            "--instruction",
            instruction,
            "--verilog-module-out-signal",
            f"{verilog_module_out_signal[0]}:{verilog_module_out_signal[1]}",
        ]
    elif instruction == None and verilog_module_filepath != None:
        # Vice versa.
        cmd += [
            "--verilog-module-filepath",
            verilog_module_filepath,
            "--verilog-module-out-signal",
            f"{verilog_module_out_signal[0]}:{verilog_module_out_signal[1]}",
            "--top-module-name",
            top_module_name,
        ]
    else:
        raise Exception(
            f"Didn't expect instruction ({instruction}) and verilog_module_filepath ({verilog_module_filepath})"
        )

    if initiation_interval != None:
        cmd += ["--initiation-interval", str(initiation_interval)]

    if inputs != None:
        for name, bitwidth in inputs:
            cmd += ["--input-signal", f"{name}:{bitwidth}"]

    if clock_name != None:
        cmd += ["--clock-name", clock_name]

    if reset_name != None:
        cmd += ["--reset-name", reset_name]

    if timeout != None:
        cmd += ["--timeout", str(timeout)]

    if extra_cycles != None:
        cmd += ["--extra-cycles", str(extra_cycles)]

    # Add requested solvers and seeds
    manifest = utils.get_manifest()
    for solver_instance in manifest["completeness_experiments"]["lakeroad"][
        "solver_instances"
    ]:
        # If it's just something like "- bitwuzla", then just turn on that sovler.
        if isinstance(solver_instance, str):
            cmd += [f"--{solver_instance}"]
        # Otherwise, if it has flags, like "- bitwuzla: {foo: bar}", then
        # activate those flags as well.
        elif isinstance(solver_instance, dict):
            assert len(solver_instance) == 1
            solver_name = list(solver_instance.keys())[0]
            solver_flag_set = ",".join(
                f"{k}={v}" for (k, v) in solver_instance[solver_name].items()
            )
            cmd += [f"--{solver_name}"]
            cmd += [f"--{solver_name}-flag-set", solver_flag_set]
        else:
            raise Exception(f"Unexpected solver_instance: {solver_instance}")

    logging.info(
        "Generating %s with command:\n%s", out_filepath, " ".join(map(str, cmd))
    )

    # Open stderr file if necessary.
    stderr_file = open(stderr_filepath, "w") if stderr_filepath else None

    start_time = time()
    proc = subprocess.run(cmd, stderr=stderr_file)
    end_time = time()

    # Close stderr file if necessary.
    if stderr_file:
        stderr_file.close()

    summary = {}
    if proc.returncode == 0:
        summary = count_resources_in_verilog_src(
            verilog_src=out_filepath.read_text(), module_name=module_name
        )

    assert "time_s" not in summary
    summary["time_s"] = end_time - start_time

    assert "returncode" not in summary
    summary["returncode"] = proc.returncode

    assert "lakeroad_synthesis_success" not in summary
    summary["lakeroad_synthesis_success"] = (
        proc.returncode == SYNTHESIS_SUCCESS_RETURN_CODE
    )

    assert "lakeroad_synthesis_timeout" not in summary
    summary["lakeroad_synthesis_timeout"] = proc.returncode == TIMEOUT_RETURN_CODE

    assert "lakeroad_synthesis_failure" not in summary
    summary["lakeroad_synthesis_failure"] = (
        proc.returncode == SYNTHESIS_FAIL_RETURN_CODE
    )

    for extra_field in extra_summary_fields:
        assert extra_field not in summary
        summary[extra_field] = extra_summary_fields[extra_field]

    json.dump(
        summary,
        fp=open(json_filepath, "w"),
    )

    # TODO(@gussmith23): There's a bug somewhere where we will produce an empty
    # file on failure. Delete that file. Figure out where the bug is.
    if (
        proc.returncode != 0
        and out_filepath.exists()
        and out_filepath.read_text() == ""
    ):
        os.remove(out_filepath)

    if check_returncode:
        proc.check_returncode()

    # Always fail on general, unexpected errors (errorcode 1).
    assert proc.returncode != 1, "Unexpected error from Lakeroad, returncode 1."


def make_lakeroad_task(
    template: str,
    out_module_name: str,
    out_dirpath: Union[str, Path],
    architecture: str,
    verilog_module_filepath: Optional[Union[str, Path]] = None,
    top_module_name: Optional[str] = None,
    verilog_module_out_signal: Optional[str] = None,
    name: Optional[str] = None,
    initiation_interval: Optional[int] = None,
    inputs: Optional[List[Tuple[str, int]]] = None,
    clock_name: Optional[str] = None,
    reset_name: Optional[str] = None,
    timeout: Optional[int] = None,
    extra_summary_fields: Dict[str, Any] = {},
    extra_cycles: Optional[int] = None,
) -> Tuple[Tuple, Dict]:
    """Creates a DoIt task for invoking Lakeroad.

    Many of this function's args are documented in invoke_lakeroad.

    Args:
        out_dirpath: Where output files should be written.

    Returns:
        A tuple of (task, filepath tuple). The filepath tuple is the list of
        output file paths within the `out_dirpath` directory. See return
        statement for order.
    """

    task = {}

    if name:
        task["name"] = name

    out_dirpath = Path(out_dirpath)

    output_filepaths = {
        "lakeroad_output_verilog": out_dirpath / "lakeroad_result.sv",
        "lakeroad_summary_json": out_dirpath / "lakeroad_summary.json",
        "lakeroad_stderr": out_dirpath / "lakeroad_stderr.txt",
    }

    task["actions"] = [
        (
            invoke_lakeroad,
            [],
            {
                "instruction": None,
                "template": template,
                "out_filepath": output_filepaths["lakeroad_output_verilog"],
                "module_name": out_module_name,
                "architecture": architecture,
                "json_filepath": output_filepaths["lakeroad_summary_json"],
                "verilog_module_filepath": verilog_module_filepath,
                "top_module_name": top_module_name,
                "verilog_module_out_signal": verilog_module_out_signal,
                "initiation_interval": initiation_interval,
                "inputs": inputs,
                "clock_name": clock_name,
                "reset_name": reset_name,
                "timeout": timeout,
                "extra_summary_fields": extra_summary_fields,
                "stderr_filepath": output_filepaths["lakeroad_stderr"],
                "extra_cycles": extra_cycles,
            },
        )
    ]

    task["file_dep"] = []
    if verilog_module_filepath:
        task["file_dep"].append(verilog_module_filepath)

    task["targets"] = list(output_filepaths.values())

    return (
        task,
        (
            output_filepaths["lakeroad_summary_json"],
            output_filepaths["lakeroad_output_verilog"],
            output_filepaths["lakeroad_stderr"],
        ),
    )


@doit.task_params(
    [
        {
            "name": "experiments_file",
            "default": str(utils.lakeroad_evaluation_dir() / "experiments.yaml"),
            "type": str,
        },
    ]
)
def task_instruction_experiments(experiments_file: str):
    """DoIt task creator for compiling instructions with various backends."""

    # TODO(@gussmith23) Use `make_lakeroad_task` above instead of this function.
    def _make_instruction_implementation_with_lakeroad_task(
        experiment: LakeroadInstructionExperiment,
        verilog_filepath: Union[str, Path],
        json_filepath: Union[str, Path],
    ):
        instruction_str = experiment.instruction.expr
        verilog_module_name = (
            experiment.implementation_action.implementation_module_name
        )
        template = experiment.implementation_action.template

        return (
            {
                "name": f"lakeroad_generate_{template}_{verilog_module_name}",
                "actions": [
                    (
                        invoke_lakeroad,
                        [],
                        {
                            "module_name": verilog_module_name,
                            "instruction": instruction_str,
                            "template": template,
                            "out_filepath": verilog_filepath,
                            "architecture": experiment.architecture.replace("_", "-"),
                            "json_filepath": json_filepath,
                            "verilog_module_out_signal": (
                                "out",
                                experiment.instruction.bitwidth,
                            ),
                            "extra_summary_fields": {
                                "tool": "lakeroad",
                                "identifier": verilog_module_name,
                                "architecture": experiment.architecture.replace(
                                    "_", "-"
                                ),
                                "template": template,
                            },
                            "inputs": experiment.instruction.inputs,
                        },
                    )
                ],
                # If I'm understanding DoIt correctly, then I think
                # instructions.yaml should be a dependency of these tasks, and
                # probably other things, too, i.e. the Lakeroad version. Basically,
                # we want to enable DoIt to figure out when instructions need to be
                # re-implemented with Lakeroad. That's the case when something about
                # the instruction description changes (and thus instructions.yaml
                # will be changed) or if Lakeroad itself is different.
                #
                # Note: Leaving the file_dep empty is fine; it will just re-run
                # Lakeroad on each instruction each time.
                "file_dep": [experiments_file],
                "targets": [verilog_filepath, json_filepath],
            },
            (json_filepath,),
        )

    with open(experiments_file) as f:
        experiments: List[LakeroadInstructionExperiment] = yaml.load(f, yaml.Loader)

    json_filepaths = []

    for experiment in experiments:
        module_name = experiment.implementation_action.implementation_module_name
        template = experiment.implementation_action.template
        architecture = experiment.architecture

        # Base output path.
        output_dirpath = (
            utils.output_dir() / "lakeroad" / architecture / module_name / template
        )

        verilog_filepath = output_dirpath / f"{module_name}.sv"
        json_filepath = output_dirpath / f"{module_name}.json"

        (task, (json_filepath,)) = _make_instruction_implementation_with_lakeroad_task(
            experiment,
            verilog_filepath=verilog_filepath,
            json_filepath=json_filepath,
        )
        yield task
        json_filepaths.append(json_filepath)

    def _impl(output_csv, json_filepaths):
        output_csv.parent.mkdir(exist_ok=True, parents=True)
        df = pd.DataFrame.from_records(
            json.load(open(filename)) for filename in json_filepaths
        )
        df.to_csv(output_csv)

    output_csv = utils.output_dir() / "lakeroad" / "lakeroad.csv"
    yield {
        "name": "lakeroad_generate_csv",
        "actions": [
            (
                _impl,
                [],
                {
                    "output_csv": output_csv,
                    "json_filepaths": json_filepaths,
                },
            )
        ],
        "file_dep": json_filepaths,
        "targets": [output_csv],
    }
