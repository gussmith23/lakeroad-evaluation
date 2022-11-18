from dataclasses import dataclass

@dataclass
class ImplementationAction:
    template: str
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
    architecture: str