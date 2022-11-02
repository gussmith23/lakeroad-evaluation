import utils
import logging
import os
from pathlib import Path
import subprocess
from typing import Iterable, Optional, Union
from doit.tools import run_once
from hardware_compilation import *


def _make_setup_calyx_task(
    filepaths: Iterable[Union[Path, str]], calyx_dirpath: Union[Path, str]
):
    """Returns a DoIt task which sets up a modified Calyx.

    We have multiple copies of Calyx in our eval, each with instruction sets
    implemented via different methods (e.g. via Lakeroad or via Vivado). This
    helper creates tasks which set up a given Calyx directory by copying in
    inserted instructions.

    Args:
      files: An iterable list of filepaths, each filepath being an instruction
        that should be inserted into Calyx.
      calyx_dirpath: Path to Calyx directory."""

    def _impl(
        filepaths: Iterable[Union[Path, str]], core_sv_filepath: Union[Path, str]
    ):

        begin_indicator = "BEGIN GENERATED CODE"
        end_indicator = "END GENERATED CODE"

        assert 0 == os.system(
            f"grep -q -e '{begin_indicator}' {core_sv_filepath}"
        ), f"Expected to find {begin_indicator} in {core_sv_filepath}"
        assert 0 == os.system(
            f"grep -q -e '{end_indicator}' {core_sv_filepath}"
        ), f"Expected to find {end_indicator} in {core_sv_filepath}"

        logging.info(
            "Clearing previous instruction implementations from %s", core_sv_filepath
        )
        assert 0 == os.system(
            f"sed -i -n '1,/{begin_indicator}/p;/{end_indicator}/,$p' {core_sv_filepath}"
        )

        logging.info("Inserting new implementations into %s", core_sv_filepath)
        for instr_filepath in filepaths:
            logging.info("Inserting %s", instr_filepath)
            os.system(
                f'sed -i -e "/^\/\/ {begin_indicator}$/r {str(instr_filepath)}" {str(core_sv_filepath)}'
            )

    core_sv_filepath = calyx_dirpath / "primitives" / "core.sv"

    return {
        "actions": [(_impl, [filepaths, core_sv_filepath])],
        "file_dep": filepaths + [core_sv_filepath],
        # Ensures that the task is only run once. Otherwise, if many tasks have
        # this task as a task_dep, this task will run repeatedly.
        "uptodate": [run_once],
    }


def _make_run_calyx_tests_task(
    calyx_dirpath: Union[str, Path],
    log_filepath: Union[str, Path],
    setup_calyx_taskname: str,
):
    """Makes a DoIt task which runs a given Calyx's test suite.

    Args:
      setup_calyx_taskname: The name of the task which sets up the Calyx directory."""

    def _impl(
        calyx_dirpath: Union[str, Path],
        log_filepath: Union[str, Path],
    ):

        logging.info("Running Calyx tests in %d", calyx_dirpath)
        log_filepath.parent.mkdir(parents=True, exist_ok=True)
        with open(log_filepath, "w") as f:
            subprocess.run(
                [
                    "bash",
                    "-c",
                    (
                        f"source {calyx_dirpath /'venv' / 'bin'/'activate'};"
                        f"runt -d -x '(relay)|(mrxl)|(ntt)|(dahlia)|(NTT)|(\[frontend\] dahlia)|(\[core\] backend)'"
                        f" {calyx_dirpath}"
                    ),
                ],
                stderr=f,
                stdout=f,
                check=True,
            )

    return {
        "actions": [(_impl, [calyx_dirpath, log_filepath])],
        "task_dep": [setup_calyx_taskname],
        "targets": [log_filepath],
    }


def _get_futil_files_to_test_with(calyx_dirpath):
    """Generates the list of Calyx files that we use for end-to-end tests."""
    return (
        list((calyx_dirpath / "tests" / "correctness" / "exp").glob("**/*.futil"))
        + list(
            (calyx_dirpath / "tests" / "correctness" / "ntt-pipeline").glob(
                "**/*.futil"
            )
        )
        + list(
            (calyx_dirpath / "tests" / "correctness" / "numeric-types").glob(
                "**/*.futil"
            )
        )
        # + list((calyx_dirpath / "tests" / "correctness" / "ref-cells").glob("**/*.futil"))
        + list((calyx_dirpath / "tests" / "correctness" / "relay").glob("**/*.futil"))
        + list(
            (calyx_dirpath / "tests" / "correctness" / "systolic").glob("**/*.futil")
        )
        + list((calyx_dirpath / "tests" / "correctness" / "tcam").glob("**/*.futil"))
    )


def _make_compile_with_fud_task(
    fud_filepath: Union[str, Path],
    futil_filepath: Union[str, Path],
    out_filepath: Union[str, Path],
    setup_calyx_taskname: Optional[str] = None,
):
    def compile_with_fud(
        fud_path: Union[str, Path],
        futil_filepath: Union[str, Path],
        out_filepath: Union[str, Path],
    ) -> str:
        """Compile the given futil file.

        Uses the fud binary at the given path; writes to the file at
        out_filepath."""

        out_filepath = Path(out_filepath)
        out_filepath.parent.mkdir(parents=True, exist_ok=True)
        subprocess.run(
            args=[
                fud_path,
                "e",
                "--to",
                "synth-verilog",
                futil_filepath,
                "-o",
                out_filepath,
                "-q",
            ],
            check=True,
        )

    out = {
        "file_dep": [futil_filepath],
        "targets": [out_filepath],
        "actions": [(compile_with_fud, [fud_filepath, futil_filepath, out_filepath])],
    }

    if setup_calyx_taskname:
        out["task_dep"] = [setup_calyx_taskname]

    return out


def _make_calyx_end_to_end_task(
    calyx_dirpath: Union[Path, str],
    output_base_dirpath: Union[Path, str],
    make_synthesis_task_fn,
    setup_calyx_taskname: Optional[str] = None,
):
    calyx_dirpath = Path(calyx_dirpath)
    output_base_dirpath = Path(output_base_dirpath)

    for futil_filepath in _get_futil_files_to_test_with(calyx_dirpath):
        relative_dir_in_calyx = futil_filepath.parent.relative_to(calyx_dirpath)
        compiled_sv_filepath = (
            output_base_dirpath
            / "compiled_with_futil"
            / relative_dir_in_calyx
            / f"{futil_filepath.stem}.sv"
        )

        compile_with_fud_task = _make_compile_with_fud_task(
            fud_filepath=calyx_dirpath / "venv" / "bin" / "fud",
            futil_filepath=futil_filepath,
            out_filepath=compiled_sv_filepath,
            setup_calyx_taskname=setup_calyx_taskname,
        )
        compile_with_fud_task["name"] = f"futil_compile_{futil_filepath}"
        yield compile_with_fud_task

        synthesis_task = make_synthesis_task_fn(
            input_filepath=compiled_sv_filepath,
            output_dirpath=output_base_dirpath
            / "synthesis_results"
            / relative_dir_in_calyx,
            module_name="main",
        )
        synthesis_task["name"] = f"synthesize_{futil_filepath}"
        yield synthesis_task


def task_calyx_setup_xilinx_ultrascale_plus_vivado():
    """Set up the calyx_vivado directory.

    This task sets up the calyx_vivado directory by copying in instruction
    implementations generated by Vivado."""
    return _make_setup_calyx_task(
        filepaths=[
            utils.output_dir() / "baseline" / "vivado" / "add1_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "add2_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "add3_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "add4_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "add8_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "add16_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "add32_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "and1_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "and2_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "and8_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "and16_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "and32_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "eq1_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "eq5_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "eq6_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "eq32_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "neq1_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "not1_1.sv",
            utils.output_dir() / "baseline" / "vivado" / "not5_1.sv",
            utils.output_dir() / "baseline" / "vivado" / "or1_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "or8_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "sub1_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "sub2_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "sub3_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "sub4_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "sub5_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "sub6_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "sub7_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "sub8_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "sub16_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "sub32_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "uge1_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "ugt1_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "ugt5_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "ule1_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "ule4_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "ult1_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "ult3_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "ult4_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "ult32_2.sv",
        ],
        calyx_dirpath=(utils.lakeroad_evaluation_dir() / "calyx_vivado"),
    )


def task_calyx_tests_xilinx_ultrascale_plus_vivado():
    """Run Calyx tests for calyx_vivado."""
    return _make_run_calyx_tests_task(
        calyx_dirpath=(utils.lakeroad_evaluation_dir() / "calyx_vivado"),
        log_filepath=(
            utils.output_dir() / "xilinx_ultrascale_plus_vivado_calyx_tests.log"
        ),
        setup_calyx_taskname="calyx_setup_xilinx_ultrascale_plus_vivado",
    )


def task_calyx_end_to_end_xilinx_ultrascale_plus_vivado():
    """Run end-to-end tests for calyx_vivado."""
    return _make_calyx_end_to_end_task(
        calyx_dirpath=(utils.lakeroad_evaluation_dir() / "calyx_vivado"),
        output_base_dirpath=(utils.output_dir() / "calyx_vivado_end_to_end"),
        make_synthesis_task_fn=make_xilinx_ultrascale_plus_vivado_synthesis_task,
        setup_calyx_taskname="calyx_setup_xilinx_ultrascale_plus_vivado",
    )
