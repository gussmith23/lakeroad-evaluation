from dataclasses import dataclass
from platform import architecture
from typing import List, Union
from pathlib import Path


@dataclass
class YosysNextpnrCompile(object):
    synth_json_relative_filepath: Union[Path, str]
    synth_sv_relative_filepath: Union[Path, str]
    yosys_log_filepath: Union[Path, str]
    nextpnr_log_filepath: Union[Path, str]
    yosys_time_filepath: Union[Path, str]
    nextpnr_time_filepath: Union[Path, str]
    nextpnr_output_sv_filepath: Union[Path, str]


@dataclass
class VivadoCompile(object):
    synth_opt_place_route_relative_filepath: Union[Path, str]
    log_filepath: Union[Path, str]
    time_filepath: Union[Path, str]


CompileAction = Union[YosysNextpnrCompile, VivadoCompile]


@dataclass
class ImplementationAction:
    template: str
    implementation_sv_filepath: Union[str, Path]
    implementation_module_name: str


@dataclass
class Instruction:
    name: str
    bitwidth: int
    arity: int
    expr: str


@dataclass
class LakeroadInstructionExperiment:
    """Defines a single instruction experiment in Lakeroad.

    An instruction experiment consists of an `instruction`, which indicates the
    instruction we are implementing, `synthesis_sketch`, which indicates the
    Lakeroad sketch we're using to implement the instruction, and zero or more
    compile_actions, which indicate how to compile the Lakeroad-implemented
    instruction."""

    instruction: Instruction
    implementation_action: ImplementationAction
    compile_actions: List[CompileAction]
    architecture: str
