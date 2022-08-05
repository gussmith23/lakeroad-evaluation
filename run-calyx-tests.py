#!/usr/bin/env python3
from pathlib import Path
import logging
import os
from typing import Union
from experiment import Experiment


def _insert_instructions_and_run_tests(
    calyx_dir: Union[str, Path], impls_dir: Union[str, Path]
):
    """Insert instruction implementations into (modified) Calyx and run tests."""

    core_sv_file = (calyx_dir / "primitives" / "core.sv",)

    logging.info("Clearing previous instruction implementations from %s", core_sv_file)
    assert not os.system(
        f"sed -i -n '1,/BEGIN GENERATED LAKEROAD CODE/p;/END GENERATED LAKEROAD CODE/,$p' {core_sv_file}"
    )

    logging.info(
        "Inserting new implementations from %s into %s", impls_dir, core_sv_file
    )
    assert not os.system(
        f'for f in {impls_dir}/* ; do sed -i -e "/^\/\/ BEGIN GENERATED LAKEROAD CODE$/r $f" {core_sv_file}; done'
    )

    # Run Calyx tests.
    logging.info("Running Calyx tests in %d", calyx_dir)
    assert not os.system(
        f"bash -c \"source {calyx_dir /'bin'/'activate'};runt -d -x '(relay)|(mrxl)|(ntt)|(dahlia)|(NTT)|(\[frontend\] dahlia)|(\[core\] backend)' {calyx_dir}\""
    )


class RunCalyxTests(Experiment):
    def __init__(
        self,
        lattice_ecp5_impls_dir,
        lattice_ecp5_calyx_dir,
        xilinx_ultrascale_plus_impls_dir,
        xilinx_ultrascale_plus_calyx_dir,
    ) -> None:
        super().__init__()

        self._lattice_ecp5_impls_dir = lattice_ecp5_impls_dir
        self._lattice_ecp5_calyx_dir = lattice_ecp5_calyx_dir
        self._xilinx_ultrascale_plus_impls_dir = xilinx_ultrascale_plus_impls_dir
        self._xilinx_ultrascale_plus_calyx_dir = xilinx_ultrascale_plus_calyx_dir

    def _run_experiment(self):
        _insert_instructions_and_run_tests(
            self._lattice_ecp5_calyx_dir, self._lattice_ecp5_impls_dir
        )
        _insert_instructions_and_run_tests(
            self._xilinx_ultrascale_plus_calyx_dir,
            self._xilinx_ultrascale_plus_impls_dir,
        )


if __name__ == "__main__":
    import argparse

    logging.basicConfig(level=os.environ.get("LOGLEVEL", "WARNING"))

    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--lattice-ecp5-impls-dir",
        help="Directory of Lattice ECP5 instruction implementations.",
        required=True,
        type=Path,
    )
    parser.add_argument(
        "--lattice-ecp5-calyx-dir",
        help="Directory of the Lattice ECP5 Calyx instance.",
        required=True,
        type=Path,
    )
    parser.add_argument(
        "--xilinx-ultrascale-plus-impls-dir",
        help="Directory of Xilinx UltraScale+ instruction implementations.",
        required=True,
        type=Path,
    )
    parser.add_argument(
        "--xilinx-ultrascale-plus-calyx-dir",
        help="Directory of the Xilinx UltraScale+ Calyx instance.",
        required=True,
        type=Path,
    )
    args = parser.parse_args()

    # Construct and run the top-level experiment.
    RunCalyxTests(**vars(args)).run()
