#!/usr/bin/env python3
from pathlib import Path
import logging
import os
from experiment import Experiment
import tempfile
import subprocess


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
        # Insert impls into calyx.
        # Clear any existing code in the file.
        assert not os.system(
            f"sed -i -n '1,/BEGIN GENERATED LAKEROAD CODE/p;/END GENERATED LAKEROAD CODE/,$p' {self._lattice_ecp5_calyx_dir / 'primitives'/'core.sv'}"
        )
        # Insert implementations into file.
        assert not os.system(
            f"for f in {self._lattice_ecp5_impls_dir}/* ; do sed -i -e \"/^\/\/ BEGIN GENERATED LAKEROAD CODE$/r $f\" {self._lattice_ecp5_calyx_dir / 'primitives'/'core.sv'}; done"
        )

        # Run Calyx tests.
        assert not os.system(
            f"bash -c \"source {self._lattice_ecp5_calyx_dir /'bin'/'activate'};runt -d -x '(relay)|(mrxl)|(ntt)|(dahlia)|(NTT)|(\[frontend\] dahlia)|(\[core\] backend)' {self._lattice_ecp5_calyx_dir}\""
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
