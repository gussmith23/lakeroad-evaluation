import utils
import logging
import subprocess
from typing import Union
from pathlib import Path


def invoke_lakeroad(
    module_name: str,
    instruction: str,
    template: str,
    out_filepath: Union[str, Path],
) -> subprocess.CompletedProcess:
    """Invoke Lakeroad to generate an instruction implementation.

    instruction: The Racket code representing the instruction. See main.rkt.

    TODO Could also allow users to specify whether Lakeroad should fail. E.g.
    addition isn't implemented on SOFA, so we could allow users to attempt to
    invoke Lakeroad to generate a SOFA add and expect the subprocess to
    terminate with an error code."""

    out_filepath.parent.mkdir(parents=True, exist_ok=True)

    cmd = [
        "racket",
        str(utils.lakeroad_evaluation_dir() / "lakeroad" / "racket" / "main.rkt"),
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
    ]
    logging.info("Generating %s with instruction:\n%s", out_filepath, " ".join(cmd))

    return subprocess.run(
        cmd,
        check=True,
    )
