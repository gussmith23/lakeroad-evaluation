"""Defines Lakeroad instruction synthesis tasks."""

import logging
import subprocess
from pathlib import Path
from time import time
from typing import List, Union

import doit
import utils
import yaml
from hardware_compilation import *
from schema import *

# These are defined in Lakeroad's main.rkt file.
TIMEOUT_RETURN_CODE = 25
SYNTHESIS_FAIL_RETURN_CODE = 26
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
    check_returncode: bool = True,
    extra_summary_fields: Dict[str, Any] = {},
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
            str(utils.lakeroad_evaluation_dir() / "lakeroad" / "bin" / "lakeroad-portfolio.py"),
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
        for (name, bitwidth) in inputs:
            cmd += ["--input-signal", f"{name}:{bitwidth}"]

    if clock_name != None:
        cmd += ["--clock-name", clock_name]

    if reset_name != None:
        cmd += ["--reset-name", reset_name]

    if timeout != None:
        cmd += ["--timeout", str(timeout)]

    logging.info(
        "Generating %s with command:\n%s", out_filepath, " ".join(map(str, cmd))
    )

    start_time = time()
    proc = subprocess.run(
        cmd,
    )
    end_time = time()

    summary = {}
    if proc.returncode == 0:
        summary = count_resources_in_verilog_src(
                verilog_src=out_filepath.read_text(), module_name=module_name
            )
        
    assert "time_s" not in summary
    summary["time_s"] = end_time-start_time

    assert "returncode" not in summary
    summary["returncode"] = proc.returncode

    assert "lakeroad_synthesis_success" not in summary
    summary["lakeroad_synthesis_success"] = proc.returncode == SYNTHESIS_SUCCESS_RETURN_CODE

    assert "lakeroad_synthesis_timeout" not in summary
    summary["lakeroad_synthesis_timeout"] = proc.returncode == TIMEOUT_RETURN_CODE

    assert "lakeroad_synthesis_failure" not in summary
    summary["lakeroad_synthesis_failure"] = proc.returncode == SYNTHESIS_FAIL_RETURN_CODE

    for extra_field in extra_summary_fields:
        assert extra_field not in summary
        summary[extra_field] = extra_summary_fields[extra_field]

    json.dump(
        summary,
            fp=open(json_filepath, "w"),
        )

    if proc.returncode != 0:
        logging.error(" " + " ".join(map(str, cmd)))
    if check_returncode: proc.check_returncode()



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
) -> Tuple[Tuple, Dict]:
    """Creates a DoIt task for invoking Lakeroad.

    Many of this function's args are documented in invoke_lakeroad.
    
    Args:
        out_dirpath: Where output files should be written.

    Returns:
        A tuple of (task, (output verilog filepath, output summary json
        filepath). The filepath tuple is the list of output file paths within
        the `out_dirpath` directory.
    """

    task = {}

    if name:
        task["name"] = name

    out_dirpath = Path(out_dirpath)

    output_filepaths = {
        "lakeroad_output_verilog": out_dirpath / "lakeroad_result.sv",
        "lakeroad_summary_json": out_dirpath / "lakeroad_summary.json",
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
                "extra_summary_fields": extra_summary_fields
            },
        )
    ]

    task["file_dep"] = []
    if verilog_module_filepath:
        task["file_dep"].append(verilog_module_filepath)


    task["targets"] = list(output_filepaths.values())

    return (task, (output_filepaths["lakeroad_output_verilog"], output_filepaths["lakeroad_summary_json"]))


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
        time_filepath: Union[str, Path],
        json_filepath: Union[str, Path],
    ):
        instruction_str = experiment.instruction.expr
        verilog_module_name = (
            experiment.implementation_action.implementation_module_name
        )
        template = experiment.implementation_action.template

        return {
            "name": f"lakeroad_generate_{template}_{verilog_module_name}",
            "actions": [
                (
                    invoke_lakeroad,
                    [
                        verilog_module_name,
                        instruction_str,
                        template,
                        verilog_filepath,
                        experiment.architecture.replace("_", "-"),
                        time_filepath,
                    ],
                    {
                        "json_filepath": json_filepath,
                        ""
                        "verilog_module_out_signal": (
                            "out",
                            experiment.instruction.bitwidth,
                        ),
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
            "targets": [verilog_filepath, time_filepath, json_filepath],
        }

    with open(experiments_file) as f:
        experiments: List[LakeroadInstructionExperiment] = yaml.load(f, yaml.Loader)

    for experiment in experiments:
        module_name = experiment.implementation_action.implementation_module_name
        template = experiment.implementation_action.template
        architecture = experiment.architecture

        # Base output path.
        output_dirpath = (
            utils.output_dir() / "lakeroad" / architecture / module_name / template
        )

        time_filepath = output_dirpath / f"{module_name}.time"
        verilog_filepath = output_dirpath / f"{module_name}.sv"
        json_filepath = output_dirpath / f"{module_name}.json"

        yield _make_instruction_implementation_with_lakeroad_task(
            experiment,
            time_filepath=time_filepath,
            verilog_filepath=verilog_filepath,
            json_filepath=json_filepath,
        )

        match experiment.architecture:
            case "lattice_ecp5":
                diamond_synthesis_task = make_lattice_ecp5_diamond_synthesis_task(
                    input_filepath=verilog_filepath,
                    output_dirpath=output_dirpath / "diamond",
                    module_name=module_name,
                )
                diamond_synthesis_task[
                    "name"
                ] = f"diamond_synthesize_{template}_{module_name}"
                yield diamond_synthesis_task

            case "xilinx_ultrascale_plus":
                # Previously this used the noopt version of synthesis. These
                # experiments don't matter as much anymore, but I also don't
                # think that's correct anymore.
                (vivado_synthesis_task, _) = (
                    make_xilinx_ultrascale_plus_vivado_synthesis_task_opt(
                        input_filepath=verilog_filepath,
                        module_name=module_name,
                        output_dirpath=output_dirpath / "vivado",
                    )
                )
                vivado_synthesis_task[
                    "name"
                ] = f"vivado_synthesize_{template}_{module_name}"
                yield vivado_synthesis_task

            case "sofa":
                # logging.warn("No synthesis implemented for SOFA.")
                pass

            case _:
                raise Exception(
                    f"Unexpected architecture value {experiment.architecture}"
                )
