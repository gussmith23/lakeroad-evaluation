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
    # elif workload == "muladdadd":
    #     function = "(a * b) + (c + d)"
    # elif workload == "muladdsub":
    #     function = "(a * b) + (c - d)"
    # elif workload == "mulsubadd":
    #     function = "(a * b) - (c + d)"
    # elif workload == "mulsubsub":
    #     function = "(a * b) - (c - d)"
    elif workload == "muland":
        function = "(a * b) & c"
    elif workload == "mulor":
        function = "(a * b) | c"
    elif workload == "mulxor":
        function = "(a * b) ^ c"
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
    bitwidth_max = 18
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
        "preaddmul": [["d", "a", "b"], ["xilinx"]],
        # "muladdadd": [["a", "b", "c", "d"], ["lattice"]],
        # "muladdsub": [["a", "b", "c", "d"], ["lattice"]],
        # "mulsubadd": [["a", "b", "c", "d"], ["lattice"]],
        # "mulsubsub": [["a", "b", "c", "d"], ["lattice"]],
        "muland": [["a", "b", "c"], ["lattice"]],
        "mulor": [["a", "b", "c"], ["lattice"]],
        "mulxor": [["a", "b", "c"], ["lattice"]],
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
    experiments = []
    for workload in workloads:
        inputs = inputs_dict[workload][0]
        backends = inputs_dict[workload][1]
        for bitwidth in range(8, bitwidth_max + 1):
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
