#!/usr/bin/env python3
"""Generate instruction implementations."""

import os
from pathlib import Path
from experiment import Experiment
import subprocess
import logging

LAKEROAD_DIR = Path(os.environ["LAKEROAD_DIR"])


def generate_instr(
    instruction_name: str,
    bitwidth: int,
    arity: int,
    instruction: str,
    architecture: str,
    output_dir: Path,
):
    """Invoke Lakeroad to generate an instruction implementation.

    instruction: The Racket code representing the instruction. See main.rkt.
    instruction_name: The identifier for the instruction, e.g. "and".

    TODO Could also allow users to specify whether Lakeroad should fail. E.g.
    addition isn't implemented on SOFA, so we could allow users to attempt to
    invoke Lakeroad to generate a SOFA add and expect the subprocess to
    terminate with an error code."""

    architecture_for_module_name = architecture.replace("-", "_")
    module_name = (
        f"lakeroad_{architecture_for_module_name}_{instruction_name}{bitwidth}_{arity}"
    )

    with open(output_dir / f"{module_name}.v", "w") as f:
        logging.info("Generating %s", f.name)
        subprocess.run(
            [
                "racket",
                f"{LAKEROAD_DIR}/racket/main.rkt",
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


class GenerateImpls(Experiment):
    def __init__(
        self,
        output_dir=Path(os.getcwd()),
        xilinx_ultrascale_plus: bool = True,
        lattice_ecp5: bool = True,
        sofa: bool = True,
    ):
        """Constructor.

        Args:
          xilinx_ultrascale_plus/lattice_ecp5/sofa: flags indicating which
            architectures to generate."""
        super().__init__()
        self._output_dir = output_dir
        if xilinx_ultrascale_plus:
            self.xilinx_ultrascale_plus_dir: Path = (
                output_dir / "xilinx_ultrascale_plus"
            )
            self.register(
                GenerateXilinxUltrascalePlusImpls(
                    output_dir=self.xilinx_ultrascale_plus_dir
                )
            )
        if lattice_ecp5:
            self.lattice_ecp5_dir = output_dir / "lattice_ecp5"
            self.register(GenerateLatticeECP5Impls(output_dir=self.lattice_ecp5_dir))
        if sofa:
            self.sofa_dir = output_dir / "sofa"
            self.register(GenerateSOFAImpls(output_dir=self.sofa_dir))


class GenerateXilinxUltrascalePlusImpls(Experiment):
    def __init__(self, output_dir=Path(os.getcwd())):
        super().__init__()
        self._output_dir = output_dir

    def _run_experiment(self):
        self._output_dir.mkdir(parents=True, exist_ok=True)

        for bw in [1, 2, 3, 4, 5, 6, 7, 8, 16, 32, 64, 128]:
            generate_instr(
                "and",
                bw,
                2,
                f"(bvand (var a {bw}) (var b {bw}))",
                "xilinx-ultrascale-plus",
                self._output_dir,
            )
            generate_instr(
                "or",
                bw,
                2,
                f"(bvor (var a {bw}) (var b {bw}))",
                "xilinx-ultrascale-plus",
                self._output_dir,
            )
            generate_instr(
                "xor",
                bw,
                2,
                f"(bvxor (var a {bw}) (var b {bw}))",
                "xilinx-ultrascale-plus",
                self._output_dir,
            )
            generate_instr(
                "not",
                bw,
                1,
                f"(bvnot (var a {bw}))",
                "xilinx-ultrascale-plus",
                self._output_dir,
            )
            generate_instr(
                "add",
                bw,
                2,
                f"(bvadd (var a {bw}) (var b {bw}))",
                "xilinx-ultrascale-plus",
                self._output_dir,
            )
            generate_instr(
                "sub",
                bw,
                2,
                f"(bvsub (var a {bw}) (var b {bw}))",
                "xilinx-ultrascale-plus",
                self._output_dir,
            )
            generate_instr(
                "eq",
                bw,
                2,
                f"(bool->bitvector (bveq (var a {bw}) (var b {bw})))",
                "xilinx-ultrascale-plus",
                self._output_dir,
            )
            generate_instr(
                "neq",
                bw,
                2,
                f"(bool->bitvector (not (bveq (var a {bw}) (var b {bw}))))",
                "xilinx-ultrascale-plus",
                self._output_dir,
            )
            generate_instr(
                "ugt",
                bw,
                2,
                f"(bool->bitvector (bvugt (var a {bw}) (var b {bw})))",
                "xilinx-ultrascale-plus",
                self._output_dir,
            )
            generate_instr(
                "ult",
                bw,
                2,
                f"(bool->bitvector (bvult (var a {bw}) (var b {bw})))",
                "xilinx-ultrascale-plus",
                self._output_dir,
            )
            generate_instr(
                "uge",
                bw,
                2,
                f"(bool->bitvector (bvuge (var a {bw}) (var b {bw})))",
                "xilinx-ultrascale-plus",
                self._output_dir,
            )
            generate_instr(
                "ule",
                bw,
                2,
                f"(bool->bitvector (bvule (var a {bw}) (var b {bw})))",
                "xilinx-ultrascale-plus",
                self._output_dir,
            )
            generate_instr(
                "mux",
                bw,
                3,
                f"(circt-comb-mux (var a 1) (var b {bw}) (var c {bw}))",
                "xilinx-ultrascale-plus",
                self._output_dir,
            )


class GenerateLatticeECP5Impls(Experiment):
    def __init__(self, output_dir=Path(os.getcwd())):
        super().__init__()
        self._output_dir = output_dir

    def _run_experiment(self):
        self._output_dir.mkdir(parents=True, exist_ok=True)

        for bw in [1, 2, 3, 4, 5, 6, 7, 8, 16, 32, 64, 128]:
            generate_instr(
                "and",
                bw,
                2,
                f"(bvand (var a {bw}) (var b {bw}))",
                "lattice-ecp5",
                self._output_dir,
            )
            generate_instr(
                "or",
                bw,
                2,
                f"(bvor (var a {bw}) (var b {bw}))",
                "lattice-ecp5",
                self._output_dir,
            )
            generate_instr(
                "xor",
                bw,
                2,
                f"(bvxor (var a {bw}) (var b {bw}))",
                "lattice-ecp5",
                self._output_dir,
            )
            generate_instr(
                "not", bw, 1, f"(bvnot (var a {bw}))", "lattice-ecp5", self._output_dir
            )
            generate_instr(
                "add",
                bw,
                2,
                f"(bvadd (var a {bw}) (var b {bw}))",
                "lattice-ecp5",
                self._output_dir,
            )
            generate_instr(
                "sub",
                bw,
                2,
                f"(bvsub (var a {bw}) (var b {bw}))",
                "lattice-ecp5",
                self._output_dir,
            )
            generate_instr(
                "eq",
                bw,
                2,
                f"(bool->bitvector (bveq (var a {bw}) (var b {bw})))",
                "lattice-ecp5",
                self._output_dir,
            )
            generate_instr(
                "neq",
                bw,
                2,
                f"(bool->bitvector (not (bveq (var a {bw}) (var b {bw}))))",
                "lattice-ecp5",
                self._output_dir,
            )
            generate_instr(
                "ugt",
                bw,
                2,
                f"(bool->bitvector (bvugt (var a {bw}) (var b {bw})))",
                "lattice-ecp5",
                self._output_dir,
            )
            generate_instr(
                "ult",
                bw,
                2,
                f"(bool->bitvector (bvult (var a {bw}) (var b {bw})))",
                "lattice-ecp5",
                self._output_dir,
            )
            generate_instr(
                "uge",
                bw,
                2,
                f"(bool->bitvector (bvuge (var a {bw}) (var b {bw})))",
                "lattice-ecp5",
                self._output_dir,
            )
            generate_instr(
                "ule",
                bw,
                2,
                f"(bool->bitvector (bvule (var a {bw}) (var b {bw})))",
                "lattice-ecp5",
                self._output_dir,
            )
            generate_instr(
                "mux",
                bw,
                3,
                f"(circt-comb-mux (var a 1) (var b {bw}) (var c {bw}))",
                "lattice-ecp5",
                self._output_dir,
            )


class GenerateSOFAImpls(Experiment):
    def __init__(self, output_dir=Path(os.getcwd())):
        super().__init__()
        self._output_dir = output_dir

    def _run_experiment(self):
        self._output_dir.mkdir(parents=True, exist_ok=True)

        for bw in [1, 2, 3, 4, 5, 6, 7, 8, 16, 32, 64, 128]:
            generate_instr(
                "and",
                bw,
                2,
                f"(bvand (var a {bw}) (var b {bw}))",
                "lattice-ecp5",
                self._output_dir,
            )
            generate_instr(
                "or",
                bw,
                2,
                f"(bvor (var a {bw}) (var b {bw}))",
                "lattice-ecp5",
                self._output_dir,
            )
            generate_instr(
                "xor",
                bw,
                2,
                f"(bvxor (var a {bw}) (var b {bw}))",
                "lattice-ecp5",
                self._output_dir,
            )
            generate_instr(
                "not", bw, 1, f"(bvnot (var a {bw}))", "lattice-ecp5", self._output_dir
            )
            generate_instr(
                "mux",
                bw,
                3,
                f"(circt-comb-mux (var a 1) (var b {bw}) (var c {bw}))",
                "lattice-ecp5",
                self._output_dir,
            )
            # generate_instr("add", bw, 2,
            #                f"(bvadd (var a {bw}) (var b {bw}))", "lattice-ecp5", self._output_dir)
            # generate_instr("sub", bw, 2,
            #                f"(bvsub (var a {bw}) (var b {bw}))", "lattice-ecp5", self._output_dir)
            # generate_instr("eq", bw, 2,
            #                f"(bool->bitvector (bveq (var a {bw}) (var b {bw})))", "lattice-ecp5", self._output_dir)
            # generate_instr("neq", bw, 2,
            #                f"(bool->bitvector (not (bveq (var a {bw}) (var b {bw}))))", "lattice-ecp5", self._output_dir)
            # generate_instr("ugt", bw, 2,
            #                f"(bool->bitvector (bvugt (var a {bw}) (var b {bw})))", "lattice-ecp5", self._output_dir)
            # generate_instr("ult", bw, 2,
            #                f"(bool->bitvector (bvult (var a {bw}) (var b {bw})))", "lattice-ecp5", self._output_dir)
            # generate_instr("uge", bw, 2,
            #                f"(bool->bitvector (bvuge (var a {bw}) (var b {bw})))", "lattice-ecp5", self._output_dir)
            # generate_instr("ule", bw, 2,
            #                f"(bool->bitvector (bvule (var a {bw}) (var b {bw})))", "lattice-ecp5", self._output_dir)


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument("--output-dir", required=True, type=Path)
    parser.add_argument(
        "--xilinx-ultrascale-plus",
        help="Generate Xilinx UltraScale+ instructions.",
        default=True,
        action=argparse.BooleanOptionalAction,
    )
    parser.add_argument(
        "--lattice-ecp5",
        help="Generate Lattice ECP5 instructions.",
        default=True,
        action=argparse.BooleanOptionalAction,
    )
    parser.add_argument(
        "--sofa",
        help="Generate SOFA instructions.",
        default=True,
        action=argparse.BooleanOptionalAction,
    )
    args = parser.parse_args()

    logging.basicConfig(
        level=os.environ.get("LOGLEVEL", "INFO"),
    )

    GenerateImpls(**vars(args))