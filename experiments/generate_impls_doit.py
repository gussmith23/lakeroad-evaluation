#!/usr/bin/env python3
"""DoIt task definition for implementing instructions with Lakeroad."""

from pathlib import Path
from typing import Dict, Union
import subprocess
import logging
import utils
import yaml
import doit


def generate_instr(
    module_name: str,
    instruction: str,
    architecture: str,
    out_filepath: Union[str, Path],
):
    """Invoke Lakeroad to generate an instruction implementation.

    instruction: The Racket code representing the instruction. See main.rkt.

    TODO Could also allow users to specify whether Lakeroad should fail. E.g.
    addition isn't implemented on SOFA, so we could allow users to attempt to
    invoke Lakeroad to generate a SOFA add and expect the subprocess to
    terminate with an error code."""

    out_filepath.parent.mkdir(parents=True, exist_ok=True)

    with open(out_filepath, "w") as f:
        logging.info("Generating %s", f.name)
        subprocess.run(
            [
                "racket",
                str(
                    utils.lakeroad_evaluation_dir() / "lakeroad" / "racket" / "main.rkt"
                ),
                "--out-format",
                "verilog",
                "--architecture",
                architecture,
                "--module-name",
                module_name,
                "--instruction",
                instruction,
            ],
            check=True,
            stdout=f,
        )


@doit.task_params(
    [
        {
            "name": "instructions_file",
            "default": str(utils.lakeroad_evaluation_dir() / "instructions.yaml"),
            "type": str,
        },
    ]
)
def task_generate_impls(instructions_file: str):
    """Doit task creator for generating instruction impls. with Lakeroad."""

    def _make_task(
        instruction: Dict,
    ):
        instruction_str = instruction["instruction"]
        architecture = instruction["architecture"]
        verilog_module_name = instruction["verilog_module_name"]
        relative_output_filepath = instruction["relative_verilog_filepath"]

        output_filepath = utils.output_dir() / relative_output_filepath

        return {
            "actions": [
                (
                    generate_instr,
                    [
                        verilog_module_name,
                        instruction_str,
                        architecture,
                        output_filepath,
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
            "file_dep": [],
            "targets": [output_filepath],
            "name": f"generate_{verilog_module_name}",
        }

    with open(instructions_file) as f:
        instructions = yaml.safe_load(f)

        for instruction in instructions:
            yield _make_task(instruction)
