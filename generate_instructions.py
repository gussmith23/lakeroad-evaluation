"""Generate YAML file of instructions to generate with Lakeroad.

By default, prints to stdout. To write to a file, use the --output-file
argument."""
import yaml


def _make_instruction(instruction_name, bitwidth, arity, instruction, architecture):
    return {
        "instruction_name": instruction_name,
        "bitwidth": bitwidth,
        "arity": arity,
        "instruction": instruction,
        "architecture": architecture,
    }


def _make_instructions():
    for bw in [1, 2, 3, 4, 5, 6, 7, 8, 16, 32, 64, 128]:
        yield _make_instruction(
            "and",
            bw,
            2,
            f"(bvand (var a {bw}) (var b {bw}))",
            "xilinx-ultrascale-plus",
        )

        yield _make_instruction(
            "or",
            bw,
            2,
            f"(bvor (var a {bw}) (var b {bw}))",
            "xilinx-ultrascale-plus",
        )
        yield _make_instruction(
            "xor",
            bw,
            2,
            f"(bvxor (var a {bw}) (var b {bw}))",
            "xilinx-ultrascale-plus",
        )
        yield _make_instruction(
            "not",
            bw,
            1,
            f"(bvnot (var a {bw}))",
            "xilinx-ultrascale-plus",
        )
        yield _make_instruction(
            "add",
            bw,
            2,
            f"(bvadd (var a {bw}) (var b {bw}))",
            "xilinx-ultrascale-plus",
        )
        yield _make_instruction(
            "sub",
            bw,
            2,
            f"(bvsub (var a {bw}) (var b {bw}))",
            "xilinx-ultrascale-plus",
        )
        yield _make_instruction(
            "eq",
            bw,
            2,
            f"(bool->bitvector (bveq (var a {bw}) (var b {bw})))",
            "xilinx-ultrascale-plus",
        )
        yield _make_instruction(
            "neq",
            bw,
            2,
            f"(bool->bitvector (not (bveq (var a {bw}) (var b {bw}))))",
            "xilinx-ultrascale-plus",
        )
        yield _make_instruction(
            "ugt",
            bw,
            2,
            f"(bool->bitvector (bvugt (var a {bw}) (var b {bw})))",
            "xilinx-ultrascale-plus",
        )
        yield _make_instruction(
            "ult",
            bw,
            2,
            f"(bool->bitvector (bvult (var a {bw}) (var b {bw})))",
            "xilinx-ultrascale-plus",
        )
        yield _make_instruction(
            "uge",
            bw,
            2,
            f"(bool->bitvector (bvuge (var a {bw}) (var b {bw})))",
            "xilinx-ultrascale-plus",
        )
        yield _make_instruction(
            "ule",
            bw,
            2,
            f"(bool->bitvector (bvule (var a {bw}) (var b {bw})))",
            "xilinx-ultrascale-plus",
        )
        yield _make_instruction(
            "mux",
            bw,
            3,
            f"(circt-comb-mux (var a 1) (var b {bw}) (var c {bw}))",
            "xilinx-ultrascale-plus",
        )

        # Lattice ECP5
        yield _make_instruction(
            "and",
            bw,
            2,
            f"(bvand (var a {bw}) (var b {bw}))",
            "lattice-ecp5",
        )
        yield _make_instruction(
            "or",
            bw,
            2,
            f"(bvor (var a {bw}) (var b {bw}))",
            "lattice-ecp5",
        )
        yield _make_instruction(
            "xor",
            bw,
            2,
            f"(bvxor (var a {bw}) (var b {bw}))",
            "lattice-ecp5",
        )
        yield _make_instruction(
            "not",
            bw,
            1,
            f"(bvnot (var a {bw}))",
            "lattice-ecp5",
        )
        yield _make_instruction(
            "add",
            bw,
            2,
            f"(bvadd (var a {bw}) (var b {bw}))",
            "lattice-ecp5",
        )
        yield _make_instruction(
            "sub",
            bw,
            2,
            f"(bvsub (var a {bw}) (var b {bw}))",
            "lattice-ecp5",
        )
        yield _make_instruction(
            "eq",
            bw,
            2,
            f"(bool->bitvector (bveq (var a {bw}) (var b {bw})))",
            "lattice-ecp5",
        )
        yield _make_instruction(
            "neq",
            bw,
            2,
            f"(bool->bitvector (not (bveq (var a {bw}) (var b {bw}))))",
            "lattice-ecp5",
        )
        yield _make_instruction(
            "ugt",
            bw,
            2,
            f"(bool->bitvector (bvugt (var a {bw}) (var b {bw})))",
            "lattice-ecp5",
        )
        yield _make_instruction(
            "ult",
            bw,
            2,
            f"(bool->bitvector (bvult (var a {bw}) (var b {bw})))",
            "lattice-ecp5",
        )
        yield _make_instruction(
            "uge",
            bw,
            2,
            f"(bool->bitvector (bvuge (var a {bw}) (var b {bw})))",
            "lattice-ecp5",
        )
        yield _make_instruction(
            "ule",
            bw,
            2,
            f"(bool->bitvector (bvule (var a {bw}) (var b {bw})))",
            "lattice-ecp5",
        )
        yield _make_instruction(
            "mux",
            bw,
            3,
            f"(circt-comb-mux (var a 1) (var b {bw}) (var c {bw}))",
            "lattice-ecp5",
        )

        # SOFA
        yield _make_instruction(
            "and",
            bw,
            2,
            f"(bvand (var a {bw}) (var b {bw}))",
            "sofa",
        )
        yield _make_instruction(
            "or",
            bw,
            2,
            f"(bvor (var a {bw}) (var b {bw}))",
            "sofa",
        )
        yield _make_instruction(
            "xor",
            bw,
            2,
            f"(bvxor (var a {bw}) (var b {bw}))",
            "sofa",
        )
        yield _make_instruction(
            "not",
            bw,
            1,
            f"(bvnot (var a {bw}))",
            "sofa",
        )
        yield _make_instruction(
            "mux",
            bw,
            3,
            f"(circt-comb-mux (var a 1) (var b {bw}) (var c {bw}))",
            "sofa",
        )
        yield _make_instruction(
            "add",
            bw,
            2,
            f"(bvadd (var a {bw}) (var b {bw}))",
            "sofa",
        )
        yield _make_instruction(
            "sub",
            bw,
            2,
            f"(bvsub (var a {bw}) (var b {bw}))",
            "sofa",
        )
        yield _make_instruction(
            "eq",
            bw,
            2,
            f"(bool->bitvector (bveq (var a {bw}) (var b {bw})))",
            "sofa",
        )
        yield _make_instruction(
            "neq",
            bw,
            2,
            f"(bool->bitvector (not (bveq (var a {bw}) (var b {bw}))))",
            "sofa",
        )
        yield _make_instruction(
            "ugt",
            bw,
            2,
            f"(bool->bitvector (bvugt (var a {bw}) (var b {bw})))",
            "sofa",
        )
        yield _make_instruction(
            "ult",
            bw,
            2,
            f"(bool->bitvector (bvult (var a {bw}) (var b {bw})))",
            "sofa",
        )
        yield _make_instruction(
            "uge",
            bw,
            2,
            f"(bool->bitvector (bvuge (var a {bw}) (var b {bw})))",
            "sofa",
        )
        yield _make_instruction(
            "ule",
            bw,
            2,
            f"(bool->bitvector (bvule (var a {bw}) (var b {bw})))",
            "sofa",
        )


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
