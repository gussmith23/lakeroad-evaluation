"""Generate YAML file of instructions to generate with Lakeroad.

By default, prints to stdout. To write to a file, use the --output-file
argument."""
from typing import Union
import yaml
from pathlib import Path
from schema import *


def _make_vivado_compile_command(
    base_output_path: Union[Path, str],
) -> VivadoCompile:
    base_output_path = Path(base_output_path)
    return VivadoCompile(
        synth_opt_place_route_relative_filepath=str(
            base_output_path / "vivado" / "synth_opt_place_route.sv"
        ),
        log_filepath=str(base_output_path / "vivado" / "vivado_log.txt"),
        time_filepath=str(base_output_path / "vivado" / "vivado.time"),
    )


def _make_yosys_nextpnr_compile_command(
    base_output_path: Union[Path, str],
) -> YosysNextpnrCompile:
    return YosysNextpnrCompile(
        synth_json_relative_filepath=str(
            base_output_path / "yosys_nextpnr" / "yosys_synth.json"
        ),
        synth_sv_relative_filepath=str(
            base_output_path / "yosys_nextpnr" / "yosys_synth.sv"
        ),
        yosys_log_filepath=str(base_output_path / "yosys_nextpnr" / "yosys_log.txt"),
        nextpnr_log_filepath=str(
            base_output_path / "yosys_nextpnr" / "nextpnr_log.txt"
        ),
        yosys_time_filepath=str(base_output_path / "yosys_nextpnr" / "yosys.time"),
        nextpnr_time_filepath=str(
            base_output_path / "yosys_nextpnr" / "nextpnr.time"
        ),
        nextpnr_output_sv_filepath=str(
            base_output_path / "yosys_nextpnr" / "nextpnr_place_route.sv"
        ),
    )


def _verilog_module_name(
    architecture: str, instruction_name: str, bitwidth: int, arity: int
):
    return f"lakeroad_{architecture}_{instruction_name}{bitwidth}_{arity}"


def _make_experiment(
    architecture: str,
    instruction: Instruction,
    template: str,
) -> LakeroadInstructionExperiment:
    module_name = _verilog_module_name(
        architecture,
        instruction.name,
        instruction.bitwidth,
        instruction.arity,
    )

    base_path = Path(architecture) / module_name / template

    if architecture == "xilinx_ultrascale_plus":
        compile_actions = [_make_vivado_compile_command(base_path)]
    elif architecture == "lattice_ecp5":
        compile_actions = [_make_yosys_nextpnr_compile_command(base_path)]
    elif architecture == "sofa":
        compile_actions = []

    return LakeroadInstructionExperiment(
        instruction=instruction,
        implementation_action=ImplementationAction(
            template=template,
            implementation_sv_filepath=str(base_path / (str(module_name) + ".sv")),
            implementation_module_name=module_name,
        ),
        compile_actions=compile_actions,
        architecture=architecture,
    )


def _make_instructions():

    for bw in [1, 2, 3, 4, 5, 6, 7, 8, 16, 32, 64, 128]:
        for instruction in [
            Instruction(
                name="and",
                bitwidth=bw,
                arity=2,
                expr=f"(bvand (var a {bw}) (var b {bw}))",
            ),
            Instruction(
                name="or",
                bitwidth=bw,
                arity=2,
                expr=f"(bvor (var a {bw}) (var b {bw}))",
            ),
            Instruction(
                name="xor",
                bitwidth=bw,
                arity=2,
                expr=f"(bvxor (var a {bw}) (var b {bw}))",
            ),
            Instruction(
                name="not",
                bitwidth=bw,
                arity=1,
                expr=f"(bvnot (var a {bw}))",
            ),
            Instruction(
                name="mux",
                bitwidth=bw,
                arity=3,
                expr=f"(circt-comb-mux (var a 1) (var b {bw}) (var c {bw}))",
            ),
        ]:
            templates = [
                ("xilinx_ultrascale_plus", "bitwise"),
                ("lattice_ecp5", "bitwise"),
                ("sofa", "bitwise"),
            ]
            # Only do DSP for <= 16 bits.
            if bw <= 16:
                templates += [
                    ("xilinx_ultrascale_plus", "xilinx-ultrascale-plus-dsp48e2")
                ]

            for (architecture, template) in templates:
                yield _make_experiment(architecture, instruction, template)

        for instruction in [
            Instruction(
                name="add",
                bitwidth=bw,
                arity=2,
                expr=f"(bvadd (var a {bw}) (var b {bw}))",
            ),
            Instruction(
                name="sub",
                bitwidth=bw,
                arity=2,
                expr=f"(bvsub (var a {bw}) (var b {bw}))",
            ),
        ]:
            templates = [
                (
                    "xilinx_ultrascale_plus",
                    "bitwise-with-carry",
                ),
                ("lattice_ecp5", "bitwise-with-carry"),
                ("sofa", "bitwise-with-carry"),
            ]
            # Only do DSP for <= 16 bits.
            if bw <= 16:
                templates += [
                    ("xilinx_ultrascale_plus", "xilinx-ultrascale-plus-dsp48e2")
                ]

            for (architecture, template) in templates:
                yield _make_experiment(architecture, instruction, template)

        for instruction in [
            Instruction(
                name="eq",
                bitwidth=bw,
                arity=2,
                expr=f"(bool->bitvector (bveq (var a {bw}) (var b {bw})))",
            ),
            Instruction(
                name="neq",
                bitwidth=bw,
                arity=2,
                expr=f"(bool->bitvector (not (bveq (var a {bw}) (var b {bw}))))",
            ),
            Instruction(
                name="ugt",
                bitwidth=bw,
                arity=2,
                expr=f"(bool->bitvector (bvugt (var a {bw}) (var b {bw})))",
            ),
            Instruction(
                name="ult",
                bitwidth=bw,
                arity=2,
                expr=f"(bool->bitvector (bvult (var a {bw}) (var b {bw})))",
            ),
            Instruction(
                name="uge",
                bitwidth=bw,
                arity=2,
                expr=f"(bool->bitvector (bvuge (var a {bw}) (var b {bw})))",
            ),
            Instruction(
                name="ule",
                bitwidth=bw,
                arity=2,
                expr=f"(bool->bitvector (bvule (var a {bw}) (var b {bw})))",
            ),
        ]:
            for (architecture, template) in [
                (
                    "xilinx_ultrascale_plus",
                    "comparison",
                ),
                ("lattice_ecp5", "comparison"),
                ("sofa", "comparison"),
            ]:
                yield _make_experiment(architecture, instruction, template)

        if bw <= 8:
            for instruction in [
                Instruction(
                    name="mul",
                    bitwidth=bw,
                    arity=2,
                    expr=f"(bvmul (var a {bw}) (var b {bw}))",
                ),
            ]:
                for (architecture, template) in [
                    (
                        "xilinx_ultrascale_plus",
                        "multiplication",
                    ),
                    ("lattice_ecp5", "multiplication"),
                    ("sofa", "multiplication"),
                ]:
                    yield _make_experiment(architecture, instruction, template)

        if bw <= 16:
            for instruction in [
                Instruction(
                    name="mul",
                    bitwidth=bw,
                    arity=2,
                    expr=f"(bvmul (var a {bw}) (var b {bw}))",
                ),
            ]:
                for (architecture, template) in [
                    (
                        "xilinx_ultrascale_plus",
                        "xilinx-ultrascale-plus-dsp48e2",
                    ),
                ]:
                    yield _make_experiment(architecture, instruction, template)


def main(output_file):
    yaml.dump(list(_make_instructions()), stream=output_file)


if __name__ == "__main__":
    import argparse
    import sys

    parser = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter
    )
    parser.add_argument(
        "--output-file", type=argparse.FileType("w"), default=sys.stdout
    )
    args = parser.parse_args()

    main(args.output_file)
