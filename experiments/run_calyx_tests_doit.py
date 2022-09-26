#!/usr/bin/env python3
from pathlib import Path
import logging
import os
from typing import Optional, Union
from experiment import Experiment
import utils
import subprocess


def _insert_instructions_and_run_tests(
    calyx_dir: Union[str, Path],
    log_file: Union[str, Path],
    impls_dir: Optional[Union[str, Path]] = None,
):
    """(Optionally) insert instruction implementations into (modified) Calyx and run tests."""

    if impls_dir is not None:
        core_sv_file = calyx_dir / "primitives" / "core.sv"

        logging.info(
            "Clearing previous instruction implementations from %s", core_sv_file
        )
        assert not os.system(
            f"sed -i -n '1,/BEGIN GENERATED LAKEROAD CODE/p;/END GENERATED LAKEROAD CODE/,$p' {str(core_sv_file)}"
        )

        logging.info(
            "Inserting new implementations from %s into %s", impls_dir, core_sv_file
        )
        assert not os.system(
            f'for f in {str(impls_dir)}/* ; do sed -i -e "/^\/\/ BEGIN GENERATED LAKEROAD CODE$/r $f" {str(core_sv_file)}; done'
        )

    # Run Calyx tests.
    logging.info("Running Calyx tests in %d", calyx_dir)
    log_file.parent.mkdir(parents=True, exist_ok=True)
    with open(log_file, "w") as f:
        subprocess.run(
            [
                "bash",
                "-c",
                f"source {calyx_dir /'venv' / 'bin'/'activate'};runt -d -x '(relay)|(mrxl)|(ntt)|(dahlia)|(NTT)|(\[frontend\] dahlia)|(\[core\] backend)' {calyx_dir}",
            ],
            stderr=f,
            stdout=f,
            check=True,
        )


def task_run_calyx_tests():

    yield {
        "name": "vanilla_calyx",
        "actions": [
            (
                _insert_instructions_and_run_tests,
                [
                    utils.lakeroad_evaluation_dir() / "calyx",
                    utils.output_dir() / "run_calyx_tests" / "vanilla_calyx.log",
                ],
            )
        ],
    }
    yield {
        "name": "xilinx_ultrascale_plus",
        "actions": [
            (
                _insert_instructions_and_run_tests,
                [
                    utils.lakeroad_evaluation_dir() / "calyx-xilinx-ultrascale-plus",
                    utils.output_dir()
                    / "run_calyx_tests"
                    / "xilinx_ultrascale_plus.log",
                    utils.output_dir() / "lakeroad_impls" / "xilinx_ultrascale_plus",
                ],
            )
        ],
    }

    yield {
        "name": "lattice_ecp5",
        "actions": [
            (
                _insert_instructions_and_run_tests,
                [
                    utils.lakeroad_evaluation_dir() / "calyx-lattice-ecp5",
                    utils.output_dir() / "run_calyx_tests" / "lattice_ecp5.log",
                    utils.output_dir() / "lakeroad_impls" / "lattice_ecp5",
                ],
            )
        ],
    }
