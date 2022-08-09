from pathlib import Path
from typing import List, Union
import subprocess


from dataclasses import dataclass


@dataclass
class VivadoCommand(object):
    pass


@dataclass
class BatchModeCommand(VivadoCommand):
    script_path: Union[str, Path]
    tclargs: List


def vivado(cmd: VivadoCommand):
    match cmd:
        case BatchModeCommand((script_path, tclargs)):
            subprocess.run(
                args=["vivado", "-mode", "batch", "-source", script_path, "-tclargs"]
                + tclargs
            )
