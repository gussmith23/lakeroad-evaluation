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


def invoke_lakeroad(
    module_name: str,
    instruction: str,
    template: str,
    out_filepath: Union[str, Path],
    architecture: str,
    time_filepath: Union[str, Path],
):
    """Invoke Lakeroad to generate an instruction implementation.

    instruction: The Racket code representing the instruction. See main.rkt.

    TODO Could also allow users to specify whether Lakeroad should fail. E.g.
    addition isn't implemented on SOFA, so we could allow users to attempt to
    invoke Lakeroad to generate a SOFA add and expect the subprocess to
    terminate with an error code."""

    out_filepath.parent.mkdir(parents=True, exist_ok=True)

    cmd = [
        "racket",
        str(utils.lakeroad_evaluation_dir() / "lakeroad" / "bin" / "main.rkt"),
        "--out-format",
        "verilog",
        "--template",
        template,
        "--module-name",
        module_name,
        "--instruction",
        instruction,
        "--out-filepath",
        out_filepath,
        "--architecture",
        architecture,
        "--verilog-module-out-signal",
        "out",
    ]
    logging.info(
        "Generating %s with instruction:\n%s", out_filepath, " ".join(map(str, cmd))
    )

    try:
        start_time = time()
        subprocess.run(
            cmd,
            check=True,
        )
        end_time = time()
    except subprocess.CalledProcessError as e:
        logging.error(" " + " ".join(map(str, cmd)))
        raise e

    with open(time_filepath, "w") as f:
        print(f"{end_time-start_time}s", file=f)


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

    def _make_instruction_implementation_with_lakeroad_task(
        experiment: LakeroadInstructionExperiment,
        verilog_filepath: Union[str, Path],
        time_filepath: Union[str, Path],
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
            "targets": [verilog_filepath, time_filepath],
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

        yield _make_instruction_implementation_with_lakeroad_task(
            experiment, time_filepath=time_filepath, verilog_filepath=verilog_filepath
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
                vivado_synthesis_task = (
                    make_xilinx_ultrascale_plus_vivado_synthesis_task_noopt(
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
                logging.warn("No synthesis implemented for SOFA.")

            case _:
                raise Exception(
                    f"Unexpected architecture value {experiment.architecture}"
                )
