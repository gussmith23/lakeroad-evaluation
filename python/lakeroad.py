"""Defines Lakeroad instruction synthesis tasks."""

import logging
import subprocess
from pathlib import Path
from time import time
from typing import Union

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
    ]
    logging.info(
        "Generating %s with instruction:\n%s", out_filepath, " ".join(map(str, cmd))
    )

    start_time = time()
    subprocess.run(
        cmd,
        check=True,
    )
    end_time = time()

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
    ):
        instruction_str = experiment.instruction.expr
        verilog_module_name = (
            experiment.implementation_action.implementation_module_name
        )
        relative_output_filepath = (
            experiment.implementation_action.implementation_sv_filepath
        )
        template = experiment.implementation_action.template

        output_filepath = utils.output_dir() / relative_output_filepath
        time_filepath = (
            utils.output_dir() / experiment.implementation_action.time_filepath
        )

        return {
            "name": f"lakeroad_generate_{template}_{verilog_module_name}",
            "actions": [
                (
                    invoke_lakeroad,
                    [
                        verilog_module_name,
                        instruction_str,
                        template,
                        output_filepath,
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
            "targets": [output_filepath],
        }

    def _make_compile_task(
        verilog_filepath, module_name, template, compile_action: CompileAction
    ):
        match compile_action:
            case VivadoCompile(
                synth_opt_place_route_relative_filepath=synth_opt_place_route_output_filepath,
                log_filepath=log_filepath,
                time_filepath=time_filepath,
            ):
                synth_opt_place_route_output_filepath = (
                    utils.output_dir() / synth_opt_place_route_output_filepath
                )
                log_filepath = utils.output_dir() / log_filepath
                time_filepath = utils.output_dir() / time_filepath
                # TODO(@gussmith23) sloppy...
                tcl_filepath = utils.output_dir() / f"{template}_{module_name}.tcl"

                return {
                    "name": f"vivado_compile_{template}_{module_name}",
                    "actions": [
                        (
                            xilinx_ultrascale_plus_vivado_synthesis,
                            [
                                verilog_filepath,
                                synth_opt_place_route_output_filepath,
                                module_name,
                                time_filepath,
                                log_filepath,
                            ],
                            {
                                "instr_src_file": verilog_filepath,
                                "synth_opt_place_route_output_filepath": synth_opt_place_route_output_filepath,
                                "module_name": module_name,
                                "time_filepath": time_filepath,
                                "tcl_script_filepath": tcl_filepath,
                                "log_path": log_filepath,
                                # TODO(@gussmith23) Do we run optimizations on
                                # Lakeroad-generated instructions? or no?
                                "directive": "runtimeoptimized",
                                "opt_design": False,
                            },
                        )
                    ],
                    "file_dep": [verilog_filepath],
                    "targets": [
                        synth_opt_place_route_output_filepath,
                        log_filepath,
                        time_filepath,
                        tcl_filepath,
                    ],
                }

            case DiamondCompile(
                output_dirpath=output_dirpath,
                log_filepath=log_filepath,
                time_filepath=time_filepath,
            ):

                task = make_lattice_ecp5_diamond_synthesis_task(
                    input_filepath=verilog_filepath,
                    output_dirpath=utils.output_dir() / output_dirpath,
                    module_name=module_name,
                )
                task["name"] = f"diamond_compile_{template}_{module_name}"
                return task

            case YosysNextpnrCompile(
                synth_json_relative_filepath=synth_json_relative_filepath,
                synth_sv_relative_filepath=synth_sv_relative_filepath,
                yosys_log_filepath=yosys_log_filepath,
                nextpnr_log_filepath=nextpnr_log_filepath,
                yosys_time_filepath=yosys_time_filepath,
                nextpnr_time_filepath=nextpnr_time_filepath,
                nextpnr_output_sv_filepath=nextpnr_output_sv_filepath,
            ):
                synth_out_sv = utils.output_dir() / synth_sv_relative_filepath
                synth_out_json = utils.output_dir() / synth_json_relative_filepath
                yosys_log_path = utils.output_dir() / yosys_log_filepath
                nextpnr_log_path = utils.output_dir() / nextpnr_log_filepath
                yosys_time_path = utils.output_dir() / yosys_time_filepath
                nextpnr_time_path = utils.output_dir() / nextpnr_time_filepath
                nextpnr_output_sv_filepath = (
                    utils.output_dir() / nextpnr_output_sv_filepath
                )

                return {
                    "name": f"yosys_nextpnr_compile_{template}_{module_name}",
                    "actions": [
                        (
                            lattice_ecp5_yosys_nextpnr_synthesis,
                            [
                                verilog_filepath,
                                module_name,
                                synth_out_sv,
                                synth_out_json,
                                yosys_time_path,
                                nextpnr_time_path,
                                yosys_log_path,
                                nextpnr_log_path,
                            ],
                        )
                    ],
                    "targets": [
                        synth_out_sv,
                        synth_out_json,
                        yosys_log_path,
                        nextpnr_log_path,
                        yosys_time_path,
                        nextpnr_time_path,
                    ],
                    "file_dep": [verilog_filepath],
                }

            case _:
                raise NotImplementedError(compile_action)

    with open(experiments_file) as f:
        experiments = yaml.load(f, yaml.Loader)

    for experiment in experiments:
        yield _make_instruction_implementation_with_lakeroad_task(experiment)
        for compile_task in experiment.compile_actions:
            yield _make_compile_task(
                utils.output_dir()
                / experiment.implementation_action.implementation_sv_filepath,
                experiment.implementation_action.implementation_module_name,
                experiment.implementation_action.template,
                compile_task,
            )
