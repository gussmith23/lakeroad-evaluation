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
    elif workload == "muladdadd":
        function = "(a * b) + (c + d)"
    elif workload == "muladdsub":
        function = "(a * b) + (c - d)"
    elif workload == "mulsubadd":
        function = "(a * b) - (c + d)"
    elif workload == "mulsubsub":
        function = "(a * b) - (c - d)"
    elif workload == "muland":
        function = "(a * b) & c"
    elif workload == "mulor":
        function = "(a * b) | c"
    elif workload == "mulxor":
        function = "(a * b) ^ c"
    else:
        raise ValueError(f"Unknown workload {workload}")

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


def generate_designs_old(design_dir: Union[str, Path]):
    bitwidth_max = 18
    inputs_dict = {
        "mult": ["a", "b"],
        "muladd": ["a", "b", "c"],
        "mulsub": ["a", "b", "c"],
        "addmuladd": ["a", "b", "c", "d"],
        "addmulsub": ["a", "b", "c", "d"],
        "submuladd": ["a", "b", "c", "d"],
        "submulsub": ["a", "b", "c", "d"],
        "addmuland": ["a", "b", "c", "d"],
        "submuland": ["a", "b", "c", "d"],
        "addmulor": ["a", "b", "c", "d"],
        "presubmul": ["a", "b", "c", "d"],
        "submulor": ["a", "b", "c", "d"],
        "addmulxor": ["a", "b", "c", "d"],
        "submulxor": ["a", "b", "c", "d"],
        "preaddmul": ["d", "a", "b"],
    }
    workloads = [key for key in inputs_dict.keys()]
    max_stages = 3
    # first, clear robustness-manifest.yml
    with open("robustness-manifest.yml", "w+") as output_file:
        output_file.write("")
    experiments = []
    for workload in workloads:
        inputs = inputs_dict[workload]
        for bitwidth in range(8, bitwidth_max + 1):
            input_tuples = [[input, bitwidth] for input in inputs]
            for is_signed in [True, False]:
                for stages in range(1, max_stages + 1):
                    for apply_xor_reduction in [True, False]:
                        title = make_title(
                            workload=workload,
                            bitwidth=bitwidth,
                            is_signed=is_signed,
                            stages=stages,
                            xor_reduction=apply_xor_reduction,
                        )
                        filename = design_dir / (title + ".sv")
                        tools = ["vivado", "lakeroad"]
                        if (not apply_xor_reduction and workload == "mult"): 
                            tools.append("diamond")
                        metadata = {
                            "module_name": title,
                            "workload": workload,
                            "bitwidth": bitwidth,
                            "is_signed": is_signed,
                            "stages": stages,
                            "xor_reduction": apply_xor_reduction,
                            "inputs": input_tuples,
                            "filepath": str(filename),
                            "tool": tools
                        }

                        experiments.append(metadata)

                        # with open("robustness-manifest.yml", "a+") as output_file:
                        #     yaml.dump(metadata, stream=output_file)

                        with open(filename, "w+") as f:
                            f.write(
                                generate_design(
                                    workload,
                                    bitwidth,
                                    is_signed,
                                    stages,
                                    inputs,
                                    apply_xor_reduction,
                                )
                            )

    with open("robustness-manifest.yml", "a+") as output_file:
        yaml.dump(experiments, stream=output_file)

def generate_designs(design_dir: Union[str, Path]):
    # the max bitwidth for the workloads
    bitwidth_max = 18
    # the workloads, their inputs, and the compilers that support them
    inputs_dict = {
        "mult": [["a", "b"], ["xilinx", "intel", "lattice"]],
        "muladd": [["a", "b", "c"], ["xilinx", "lakeroad", "lattice"]], 
        "mulsub": [["a", "b", "c"], ["xilinx", "lakeroad", "lattice"]],

        "addmuladd": [["a", "b", "c", "d"], ["xilinx", "lakeroad"]],
        "addmulsub": [["a", "b", "c", "d"], ["xilinx", "lakeroad"]],
        "submuladd": [["a", "b", "c", "d"], ["xilinx", "lakeroad"]],
        "submulsub": [["a", "b", "c", "d"], ["xilinx", "lakeroad"]],
        "addmuland": [["a", "b", "c", "d"], ["xilinx", "lakeroad"]],
        "submuland": [["a", "b", "c", "d"], ["xilinx", "lakeroad"]],
        "addmulor": [["a", "b", "c", "d"], ["xilinx", "lakeroad"]],
        "presubmul": [["a", "b", "c", "d"], ["xilinx", "lakeroad"]],
        "submulor": [["a", "b", "c", "d"], ["xilinx", "lakeroad"]],
        "addmulxor": [["a", "b", "c", "d"], ["xilinx", "lakeroad"]],
        "submulxor": [["a", "b", "c", "d"], ["xilinx", "lakeroad"]],
        "preaddmul": [["d", "a", "b"], ["xilinx", "lakeroad"]],

        "muladdadd": [["a", "b", "c", "d"], ["lattice", "lakeroad"]],
        "muladdsub": [["a", "b", "c", "d"], ["lattice", "lakeroad"]],
        "mulsubadd": [["a", "b", "c", "d"], ["lattice", "lakeroad"]],
        "mulsubsub": [["a", "b", "c", "d"], ["lattice", "lakeroad"]],
        "muland": [["a", "b", "c"], ["lattice", "lakeroad"]],
        "mulor": [["a", "b", "c"], ["lattice", "lakeroad"]],
        "mulxor": [["a", "b", "c"], ["lattice", "lakeroad"]]
    }
    workloads = [key for key in inputs_dict.keys()]
    max_stages = 3

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
                for stages in range(1, max_stages + 1):
                    if "xilinx" in backends:
                        title = make_title(
                            workload=workload,
                            bitwidth=bitwidth,
                            is_signed=is_signed,
                            stages=stages,
                            xor_reduction=True,
                        )
                        filename = design_dir / (title + ".sv")
                        metadata = {
                            "module_name": title,
                            "workload": workload,
                            "bitwidth": bitwidth,
                            "is_signed": is_signed,
                            "stages": stages,
                            "xor_reduction": True,
                            "inputs": input_tuples,
                            "filepath": str(filename),
                            "backends": ["xilinx", "lakeroad"]
                        }
                        experiments.append(metadata)
                        with open(filename, "w+") as f:
                            f.write(
                                generate_design(
                                    workload,
                                    bitwidth,
                                    is_signed,
                                    stages,
                                    inputs,
                                    True,
                                )
                            )
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
                        "filepath": str(filename),
                        "backends": backends
                    }
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
