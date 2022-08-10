#!/usr/bin/env python3
import io
from pathlib import Path
import logging
import os
import subprocess
from typing import Union
from experiment import Experiment


def compile_with_fud(
    fud_path: Union[str, Path],
    futil_filepath: Union[str, Path],
) -> str:
    """Compile the given futil file with the fud at the given path.

    Returns the resulting SystemVerilog as a string."""

    out = io.StringIO()
    subprocess.run(
        args=[fud_path, "e", "--to", "synth-verilog", futil_filepath],
        check=True,
        stdout=out,
    )
    return out.getvalue()


class CompileCalyxFutilFiles(Experiment):
    def __init__(
        self,
        output_dir: Union[str, Path],
        calyx_path: Union[str, Path],
        fud_path: Union[str, Path],
        overwrite_output_dir: bool = False,
    ) -> None:
        super().__init__()
        self._output_dir = output_dir
        self._overwrite_output_dir = overwrite_output_dir
        self._calyx_path = calyx_path
        self._fud_path = fud_path

    def _run_experiment(self):
        self._output_dir.mkdir(parents=True, exist_ok=self._overwrite_output_dir)

        # TODO(@gussmith23): ignore ref-cells.
        # futil_files=$(find $BASE_DIR/calyx/tests/correctness/ \( -name '*.futil' ! -wholename '*ref-cells/*' \) )
        for futil_file in (self._calyx_path / "tests" / "correctness").glob(
            "**/*.futil"
        ):
            with open(self._output_dir / f"{futil_file.name}.sv", "w") as f:
                f.write(
                    compile_with_fud(fud_path=self._fud_path, futil_filepath=futil_file)
                )


if __name__ == "__main__":
    import argparse

    logging.basicConfig(level=os.environ.get("LOGLEVEL", "WARNING"))

    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--output-dir",
        help="Output directory.",
        required=True,
        type=Path,
    )
    parser.add_argument(
        "--calyx-dir",
        help="Directory of Calyx.",
        required=True,
        type=Path,
    )
    parser.add_argument(
        "--fud-path",
        help="Path to fud binary",
        required=True,
        type=Path,
    )
    parser.add_argument(
        "--xilinx-ultrascale-plus-calyx-dir",
        help="Directory of the Xilinx UltraScale+ Calyx instance.",
        required=True,
        type=Path,
    )
    parser.add_argument(
        "--overwrite-output-dir",
        help="Whether or not to overwrite the output dir, if it exists.",
        default=False,
        action=argparse.BooleanOptionalAction,
    )
    args = parser.parse_args()

    # Construct and run the top-level experiment.
    CompileCalyxFutilFiles(**vars(args)).run()
