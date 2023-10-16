import utils
import sys
from typing import List, Union
from pathlib import Path

import yaml
from utils import lakeroad_evaluation_dir


placeholder = "placeholder"


def make_title(
    workload: str, bitwidth: int, is_signed: bool, stages: int, xor_reduction: bool
):
    signedness_title = "signed" if is_signed else "unsigned"
    base = f"{workload}_{stages}_stage_{signedness_title}_{bitwidth}_bit"
    if xor_reduction:
        base += "_xor_reduction"
    return base


def generate_design(
    workload: str,
    bitwidth: int,
    is_signed: bool,
    stages: int,
    inputs: List[str],
    apply_xor_reduction: bool,
) -> None:
    """
    Generate a design for a given workload, bitwidth, signedness, number of stages, and inputs.
    """
    signedness = "signed" if is_signed else ""

    # Module header
    result = (
        '(* use_dsp = "yes" *) module '
        + make_title(
            workload=workload,
            bitwidth=bitwidth,
            is_signed=is_signed,
            stages=stages,
            xor_reduction=apply_xor_reduction,
        )
        + "(\n"
    )

    # Inputs
    result += ",\n".join(
        [f"\tinput {signedness} [{bitwidth - 1}:0] {input}" for input in inputs]
    )

    result += f",\n\toutput [{bitwidth - 1}:0] out,\n"
    result += "\tinput clk);\n\n"

    # Pipeline registers
    reg_bitwidth = bitwidth * 2
    for i in range(stages):
        result += f"\tlogic {signedness} [{reg_bitwidth - 1}:0] stage{i};\n"

    # Pipeline logic
    if stages != 0:
        result += "\n"
        result += "\talways @(posedge clk) begin\n"

    function = ""
    if workload == "mult":
        function = " * ".join(inputs)
    elif workload == "muladd":
        function = "(a * b) + c"
    elif workload == "mulsub":
        function = "(a * b) - c"
    elif workload == "preaddmul":
        function = "(d + a) * b"
    elif workload == "presubmul":
        function = "(d - a) * b"
    elif workload == "addmuladd":
        function = "((d + a) * b) + c"
    elif workload == "addmulsub":
        function = "((d + a) * b) - c"
    elif workload == "submuladd":
        function = "((d - a) * b) + c"
    elif workload == "submulsub":
        function = "((d - a) * b) - c"
    elif workload == "addmuland":
        function = "((d + a) * b) & c"
    elif workload == "submuland":
        function = "((d - a) * b) & c"
    elif workload == "addmulor":
        function = "((d + a) * b) | c"
    elif workload == "submulor":
        function = "((d - a) * b) | c"
    elif workload == "addmulxor":
        function = "((d + a) * b) ^ c"
    elif workload == "submulxor":
        function = "((d - a) * b) ^ c"
    elif workload == "muland":
        function = "(a * b) & c"
    elif workload == "mulor":
        function = "(a * b) | c"
    elif workload == "mulxor":
        function = "(a * b) ^ c"
    elif workload == "addaddsquare_a":
        function = "c + ((d + a) * (d + a))"
    elif workload == "subaddsquare_a":
        function = "c - ((d + a) * (d + a))"
    elif workload == "subsubsquare_a":
        function = "c - ((d - a) * (d - a))"
    elif workload == "subsquare_a":
        function = "(d - a) * (d - a)"
    elif workload == "addsquare_a":
        function = "(d + a) * (d + a)"
    elif workload == "addaddsquare_b":
        function = "c + ((d + b) * (d + b))"
    elif workload == "subaddsquare_b":
        function = "c - ((d + b) * (d + b))"
    elif workload == "subsubsquare_b":
        function = "c - ((d - b) * (d - b))"
    elif workload == "addsquare_b":
        function = "(d - a) * (d - a)"
    elif workload == "subsquare_b":
        function = "(d - b) * (d - b)"
    else:
        raise ValueError(f"Unknown workload {workload}")

    if stages == 0:
        result += f"\tassign out = {function};\n"
        result += "endmodule\n"
        return result

    result += f"\tstage0 <= {function};\n"

    result += "\n".join(f"\tstage{i} <= stage{i - 1};" for i in range(1, stages))
    result += "\n\tend\n\n"

    assignment = f"stage{stages - 1}"
    if apply_xor_reduction:
        assignment = "^(" + assignment + ")"
    assignment += ";"

    result += f"\tassign out = {assignment}\n"
    result += "endmodule\n"

    return result


def generate_designs(design_dir: Union[str, Path]):
    # the max bitwidth for the workloads
    bitwidth_max = 8  # TODO: make this bigger again
    # the workloads, their inputs, and the compilers that support them
    inputs_dict = {
        "mult": [["a", "b"], ["xilinx", "intel", "lattice"]],
        "muladd": [["a", "b", "c"], ["xilinx", "lattice"]],
        "mulsub": [["a", "b", "c"], ["xilinx", "lattice"]],
        "addmuladd": [["a", "b", "c", "d"], ["xilinx"]],
        "addmulsub": [["a", "b", "c", "d"], ["xilinx"]],
        "submuladd": [["a", "b", "c", "d"], ["xilinx"]],
        "submulsub": [["a", "b", "c", "d"], ["xilinx"]],
        "addmuland": [["a", "b", "c", "d"], ["xilinx"]],
        "submuland": [["a", "b", "c", "d"], ["xilinx"]],
        "addmulor": [["a", "b", "c", "d"], ["xilinx"]],
        "presubmul": [["a", "b", "c", "d"], ["xilinx"]],
        "submulor": [["a", "b", "c", "d"], ["xilinx"]],
        "addmulxor": [["a", "b", "c", "d"], ["xilinx"]],
        "submulxor": [["a", "b", "c", "d"], ["xilinx"]],
        "preaddmul": [["a", "b", "d"], ["xilinx"]],
        "muland": [["a", "b", "c"], ["lattice"]],
        "mulor": [["a", "b", "c"], ["lattice"]],
        "mulxor": [["a", "b", "c"], ["lattice"]],
        "addaddsquare_a": [["a", "c", "d"], ["xilinx"]],
        "subaddsquare_a": [["a", "c", "d"], ["xilinx"]],
        "subsubsquare_a": [["a", "c", "d"], ["xilinx"]],
        "subsquare_a": [["a", "d"], ["xilinx"]],
        "addsquare_a": [["a", "d"], ["xilinx"]],
        "addaddsquare_b": [["b", "c", "d"], ["xilinx"]],
        "subaddsquare_b": [["b", "c", "d"], ["xilinx"]],
        "subsubsquare_b": [["b", "c", "d"], ["xilinx"]],
        "addsquare_b": [["a", "d"], ["xilinx"]],
        "subsquare_b": [["b", "d"], ["xilinx"]],
    }
    workloads = [key for key in inputs_dict.keys()]
    max_stages = 3
    # On proprietary tools, this means that we expect the tool to not map
    # workload to a single DSP. For Lakeroad, this means we expect a synthesis
    # failure.
    expect_fail = {
        make_title("addmulor", 9, False, 3, False): [
            "lakeroad-xilinx",
            "vivado",
            "yosys-xilinx",
        ]
    }
    expect_timeout = {}
    # first, clear robustness-manifest.yml
    with open("robustness-manifest.yml", "w+") as output_file:
        output_file.write("")
    experiments = [
        # {
        # "module_name": "simd_dual_add",
        # "workload": "simddualadd",
        # "bitwidth": 48,
        # "is_signed": False,
        # "stages": 0,
        # "xor_reduction": False,
        # "inputs": ["a", "b"],
        # "filepath": str(
        # Path("verilog/robustness-designs/simd_dual_add.v").relative_to(
        # utils.lakeroad_evaluation_dir()
        # )
        # ),
        # },
        # {
        # "module_name": "simd_dual_sub",
        # "workload": "simddualsub",
        # "bitwidth": 48,
        # "is_signed": False,
        # "stages": 0,
        # "xor_reduction": False,
        # "inputs": ["a", "b"],
        # "filepath": str(
        # Path("verilog/robustness-designs/simd_dual_sub.v").relative_to(
        # utils.lakeroad_evaluation_dir()
        # )
        # ),
        # },
        # {
        # "module_name": "simd_dual_acc",
        # "workload": "simddualacc",
        # "bitwidth": 48,
        # "is_signed": False,
        # "stages": 0,
        # "xor_reduction": False,
        # "inputs": ["clk", "val", "acc"],
        # "filepath": str(
        # Path("verilog/robustness-designs/simd_dual_acc.v").relative_to(
        # utils.lakeroad_evaluation_dir()
        # )
        # ),
        # },
        # {
        # "module_name": "simd_dual_counter",
        # "workload": "simddualcounter",
        # "bitwidth": 48,
        # "is_signed": False,
        # "stages": 0,
        # "xor_reduction": False,
        # "inputs": ["clk", "enable"],
        # "filepath": str(
        # Path("verilog/robustness-designs/simd_dual_counter.v").relative_to(
        # utils.lakeroad_evaluation_dir()
        # )
        # ),
        # },
        # {
        # "module_name": "simd_quad_add",
        # "workload": "simdquadadd",
        # "bitwidth": 48,
        # "is_signed": False,
        # "stages": 0,
        # "xor_reduction": False,
        # "inputs": ["a", "b"],
        # "filepath": str(
        # Path("verilog/robustness-designs/simd_quad_add.v").relative_to(
        # utils.lakeroad_evaluation_dir()
        # )
        # ),
        # },
        # {
        # "module_name": "simd_quad_sub",
        # "workload": "simdquadsub",
        # "bitwidth": 48,
        # "is_signed": False,
        # "stages": 0,
        # "xor_reduction": False,
        # "inputs": ["a", "b"],
        # "filepath": str(
        # Path("verilog/robustness-designs/simd_quad_sub.v").relative_to(
        # utils.lakeroad_evaluation_dir()
        # )
        # ),
        # },
        # {
        # "module_name": "simd_quad_acc",
        # "workload": "simdquadacc",
        # "bitwidth": 48,
        # "is_signed": False,
        # "stages": 0,
        # "xor_reduction": False,
        # "inputs": ["clk", "val", "acc"],
        # "filepath": str(
        # Path("verilog/robustness-designs/simd_quad_acc.v").relative_to(
        # utils.lakeroad_evaluation_dir()
        # )
        # ),
        # },
        # {
        # "module_name": "simd_quad_counter",
        # "workload": "simdquadcounter",
        # "bitwidth": 48,
        # "is_signed": False,
        # "stages": 0,
        # "xor_reduction": False,
        # "inputs": ["clk", "enable"],
        # "filepath": str(
        # Path("verilog/robustness-designs/simd_quad_counter.v").relative_to(
        # utils.lakeroad_evaluation_dir()
        # )
        # ),
        # },
        # {
        # "module_name": "xor_reduction_96",
        # "workload": "xorreduction96",
        # "bitwidth": 96,
        # "is_signed": False,
        # "stages": 0,
        # "xor_reduction": True,
        # "inputs": ["a"],
        # "filepath": str(
        # Path("verilog/robustness-designs/xor_reduction_96.v").relative_to(
        # utils.lakeroad_evaluation_dir()
        # )
        # ),
        # },
        # {
        # "module_name": "xor_reduction_48",
        # "workload": "xorreduction48",
        # "bitwidth": 48,
        # "is_signed": False,
        # "stages": 0,
        # "xor_reduction": True,
        # "inputs": ["a"],
        # "filepath": str(
        # Path("verilog/robustness-designs/xor_reduction_48.v").relative_to(
        # utils.lakeroad_evaluation_dir()
        # )
        # ),
        # },
        # {
        # "module_name": "xor_reduction_24",
        # "workload": "xorreduction24",
        # "bitwidth": 24,
        # "is_signed": False,
        # "stages": 0,
        # "xor_reduction": True,
        # "inputs": ["a"],
        # "filepath": str(
        # Path("verilog/robustness-designs/xor_reduction_24.v").relative_to(
        # utils.lakeroad_evaluation_dir()
        # )
        # ),
        # },
        {
            "module_name": "xor_reduction_12",
            "workload": "xorreduction12",
            "bitwidth": 12,
            "is_signed": False,
            "stages": 0,
            "xor_reduction": True,
            "inputs": [["a", 12]],
            "filepath": str(
                Path(
                    utils.lakeroad_evaluation_dir()
                    / "robustness-testing-verilog-files"
                    / "extra-designs"
                    / "xor_reduction_12.v"
                ).relative_to(utils.lakeroad_evaluation_dir())
            ),
            "backends": ["xilinx"],
        },
    ]
    for workload in workloads:
        inputs = inputs_dict[workload][0]
        backends = inputs_dict[workload][1]
        for bitwidth in range(1, bitwidth_max + 1):
            input_tuples = [[input, bitwidth] for input in inputs]
            for is_signed in [True, False]:
                for stages in range(0, max_stages + 1):
                    title = make_title(
                        workload=workload,
                        bitwidth=bitwidth,
                        is_signed=is_signed,
                        stages=stages,
                        xor_reduction=False,
                    )
                    filename = design_dir / (title + ".sv")
                    metadata = {
                        "module_name": title,
                        "workload": workload,
                        "bitwidth": bitwidth,
                        "is_signed": is_signed,
                        "stages": stages,
                        "xor_reduction": False,
                        "inputs": input_tuples,
                        "filepath": str(
                            Path(filename).relative_to(utils.lakeroad_evaluation_dir())
                        ),
                        "backends": backends,
                    }
                    metadata["expect_fail"] = []
                    if title in expect_fail:
                        metadata["expect_fail"] = expect_fail[title]
                    if title in expect_timeout:
                        metadata["expect_timeout"] = expect_timeout[title]
                    if workload != "mult" and "xilinx" in backends:
                        # yosys will only map mults to a dsp on xilinx backends, so it will fail on anything else.
                        metadata["expect_fail"].append("yosys-xilinx")
                    experiments.append(metadata)

                    with open(filename, "w+") as f:
                        f.write(
                            generate_design(
                                workload,
                                bitwidth,
                                is_signed,
                                stages,
                                inputs,
                                False,
                            )
                        )
    with open("robustness-manifest.yml", "a+") as output_file:
        # Keep this line below if you want to remove the aliases
        # yaml.Dumper.ignore_aliases = lambda self, data: True
        yaml.dump(experiments, stream=output_file)


if __name__ == "__main__":
    generate_designs(
        design_dir=lakeroad_evaluation_dir()
        / "robustness-testing-verilog-files"
        / "generated"
    )
