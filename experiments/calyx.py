import utils
import logging
import os
from pathlib import Path
import subprocess
from typing import Iterable, List, Optional, Union
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
    setup_calyx_taskname: Optional[str] = None,
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

    task = {
        "actions": [(_impl, [calyx_dirpath, log_filepath])],
        "targets": [log_filepath],
    }
    if setup_calyx_taskname:
        task["task_dep"] = [setup_calyx_taskname]
    return task


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
        # Disabling these tests as they cause the following error when
        # synthesized via Diamond:
        # ERROR - synthesis: Multiple Non-Tristate drivers exist for net clk.
        # They work fine via Vivado.
        # + list((calyx_dirpath / "tests" / "correctness" / "tcam").glob("**/*.futil"))
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
            / relative_dir_in_calyx
            / futil_filepath.name,
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


def task_calyx_setup_lattice_ecp5_diamond():
    """Set up the calyx_lattice_ecp5_diamond directory."""
    return _make_setup_calyx_task(
        filepaths=[
            utils.output_dir() / "baseline" / "diamond" / "add1_2" / "add1_2_prim.v",
            utils.output_dir() / "baseline" / "diamond" / "add2_2" / "add2_2_prim.v",
            utils.output_dir() / "baseline" / "diamond" / "add3_2" / "add3_2_prim.v",
            utils.output_dir() / "baseline" / "diamond" / "add4_2" / "add4_2_prim.v",
            utils.output_dir() / "baseline" / "diamond" / "add8_2" / "add8_2_prim.v",
            utils.output_dir() / "baseline" / "diamond" / "add16_2" / "add16_2_prim.v",
            utils.output_dir() / "baseline" / "diamond" / "add32_2" / "add32_2_prim.v",
            utils.output_dir() / "baseline" / "diamond" / "and1_2" / "and1_2_prim.v",
            utils.output_dir() / "baseline" / "diamond" / "and2_2" / "and2_2_prim.v",
            utils.output_dir() / "baseline" / "diamond" / "and8_2" / "and8_2_prim.v",
            utils.output_dir() / "baseline" / "diamond" / "and16_2" / "and16_2_prim.v",
            utils.output_dir() / "baseline" / "diamond" / "and32_2" / "and32_2_prim.v",
            utils.output_dir() / "baseline" / "diamond" / "eq1_2" / "eq1_2_prim.v",
            utils.output_dir() / "baseline" / "diamond" / "eq5_2" / "eq5_2_prim.v",
            utils.output_dir() / "baseline" / "diamond" / "eq6_2" / "eq6_2_prim.v",
            utils.output_dir() / "baseline" / "diamond" / "eq32_2" / "eq32_2_prim.v",
            utils.output_dir() / "baseline" / "diamond" / "neq1_2" / "neq1_2_prim.v",
            utils.output_dir() / "baseline" / "diamond" / "not1_1" / "not1_1_prim.v",
            utils.output_dir() / "baseline" / "diamond" / "not5_1" / "not5_1_prim.v",
            utils.output_dir() / "baseline" / "diamond" / "or1_2" / "or1_2_prim.v",
            utils.output_dir() / "baseline" / "diamond" / "or8_2" / "or8_2_prim.v",
            utils.output_dir() / "baseline" / "diamond" / "sub1_2" / "sub1_2_prim.v",
            utils.output_dir() / "baseline" / "diamond" / "sub2_2" / "sub2_2_prim.v",
            utils.output_dir() / "baseline" / "diamond" / "sub3_2" / "sub3_2_prim.v",
            utils.output_dir() / "baseline" / "diamond" / "sub4_2" / "sub4_2_prim.v",
            utils.output_dir() / "baseline" / "diamond" / "sub5_2" / "sub5_2_prim.v",
            utils.output_dir() / "baseline" / "diamond" / "sub6_2" / "sub6_2_prim.v",
            utils.output_dir() / "baseline" / "diamond" / "sub7_2" / "sub7_2_prim.v",
            utils.output_dir() / "baseline" / "diamond" / "sub8_2" / "sub8_2_prim.v",
            utils.output_dir() / "baseline" / "diamond" / "sub16_2" / "sub16_2_prim.v",
            utils.output_dir() / "baseline" / "diamond" / "sub32_2" / "sub32_2_prim.v",
            utils.output_dir() / "baseline" / "diamond" / "uge1_2" / "uge1_2_prim.v",
            utils.output_dir() / "baseline" / "diamond" / "ugt1_2" / "ugt1_2_prim.v",
            utils.output_dir() / "baseline" / "diamond" / "ugt5_2" / "ugt5_2_prim.v",
            utils.output_dir() / "baseline" / "diamond" / "ule1_2" / "ule1_2_prim.v",
            utils.output_dir() / "baseline" / "diamond" / "ule4_2" / "ule4_2_prim.v",
            utils.output_dir() / "baseline" / "diamond" / "ult1_2" / "ult1_2_prim.v",
            utils.output_dir() / "baseline" / "diamond" / "ult3_2" / "ult3_2_prim.v",
            utils.output_dir() / "baseline" / "diamond" / "ult4_2" / "ult4_2_prim.v",
            utils.output_dir() / "baseline" / "diamond" / "ult32_2" / "ult32_2_prim.v",
        ],
        calyx_dirpath=(utils.lakeroad_evaluation_dir() / "calyx_lattice_ecp5_diamond"),
    )


def task_calyx_tests_lattice_ecp5_diamond():
    """Run Calyx tests for calyx_lattice_ecp5_diamond."""
    return _make_run_calyx_tests_task(
        calyx_dirpath=(utils.lakeroad_evaluation_dir() / "calyx_lattice_ecp5_diamond"),
        log_filepath=(utils.output_dir() / "lattice_ecp5_diamond_calyx_tests.log"),
        setup_calyx_taskname="calyx_setup_lattice_ecp5_diamond",
    )


def task_calyx_end_to_end_lattice_ecp5_diamond():
    """Run end-to-end tests for calyx_lattice_ecp5_diamond."""
    return _make_calyx_end_to_end_task(
        calyx_dirpath=(utils.lakeroad_evaluation_dir() / "calyx_lattice_ecp5_diamond"),
        output_base_dirpath=(
            utils.output_dir() / "calyx_lattice_ecp5_diamond_end_to_end"
        ),
        make_synthesis_task_fn=make_lattice_ecp5_diamond_synthesis_task,
        setup_calyx_taskname="calyx_setup_lattice_ecp5_diamond",
    )


def task_calyx_tests_vanilla_calyx():
    """Run Calyx tests for vanilla Calyx."""
    return _make_run_calyx_tests_task(
        calyx_dirpath=(utils.lakeroad_evaluation_dir() / "calyx"),
        log_filepath=(utils.output_dir() / "vanilla_calyx_tests.log"),
    )


def task_vanilla_calyx_end_to_end_xilinx_ultrascale_plus_vivado():
    """Run end-to-end tests for vanilla Calyx, synthesizing with Vivado."""
    return _make_calyx_end_to_end_task(
        calyx_dirpath=(utils.lakeroad_evaluation_dir() / "calyx"),
        output_base_dirpath=(utils.output_dir() / "vanilla_calyx_vivado_end_to_end"),
        make_synthesis_task_fn=make_xilinx_ultrascale_plus_vivado_synthesis_task,
    )


def task_vanilla_calyx_end_to_end_lattice_ecp5_diamond():
    """Run end-to-end tests for vanilla Calyx, synthesizing with Diamond."""
    return _make_calyx_end_to_end_task(
        calyx_dirpath=(utils.lakeroad_evaluation_dir() / "calyx"),
        output_base_dirpath=(utils.output_dir() / "vanilla_calyx_diamond_end_to_end"),
        make_synthesis_task_fn=make_lattice_ecp5_diamond_synthesis_task,
    )


def task_calyx_setup_lattice_ecp5_lakeroad():
    """Set up the calyx-lattice-ecp5 directory.

    This is the version of Calyx with instructions pre-synthesized by Lakeroad.

    TODO(@gussmith23): Rename directory to include lakeroad."""
    return _make_setup_calyx_task(
        filepaths=[
            utils.output_dir()
            / "lattice_ecp5"
            / "lakeroad_lattice_ecp5_add1_2"
            / "bitwise-with-carry"
            / "diamond"
            / "lakeroad_lattice_ecp5_add1_2_prim.v",
            utils.output_dir()
            / "lattice_ecp5"
            / "lakeroad_lattice_ecp5_add2_2"
            / "bitwise-with-carry"
            / "diamond"
            / "lakeroad_lattice_ecp5_add2_2_prim.v",
            utils.output_dir()
            / "lattice_ecp5"
            / "lakeroad_lattice_ecp5_add3_2"
            / "bitwise-with-carry"
            / "diamond"
            / "lakeroad_lattice_ecp5_add3_2_prim.v",
            utils.output_dir()
            / "lattice_ecp5"
            / "lakeroad_lattice_ecp5_add4_2"
            / "bitwise-with-carry"
            / "diamond"
            / "lakeroad_lattice_ecp5_add4_2_prim.v",
            utils.output_dir()
            / "lattice_ecp5"
            / "lakeroad_lattice_ecp5_add8_2"
            / "bitwise-with-carry"
            / "diamond"
            / "lakeroad_lattice_ecp5_add8_2_prim.v",
            utils.output_dir()
            / "lattice_ecp5"
            / "lakeroad_lattice_ecp5_add16_2"
            / "bitwise-with-carry"
            / "diamond"
            / "lakeroad_lattice_ecp5_add16_2_prim.v",
            utils.output_dir()
            / "lattice_ecp5"
            / "lakeroad_lattice_ecp5_add32_2"
            / "bitwise-with-carry"
            / "diamond"
            / "lakeroad_lattice_ecp5_add32_2_prim.v",
            utils.output_dir()
            / "lattice_ecp5"
            / "lakeroad_lattice_ecp5_and1_2"
            / "bitwise"
            / "diamond"
            / "lakeroad_lattice_ecp5_and1_2_prim.v",
            utils.output_dir()
            / "lattice_ecp5"
            / "lakeroad_lattice_ecp5_and2_2"
            / "bitwise"
            / "diamond"
            / "lakeroad_lattice_ecp5_and2_2_prim.v",
            utils.output_dir()
            / "lattice_ecp5"
            / "lakeroad_lattice_ecp5_and8_2"
            / "bitwise"
            / "diamond"
            / "lakeroad_lattice_ecp5_and8_2_prim.v",
            utils.output_dir()
            / "lattice_ecp5"
            / "lakeroad_lattice_ecp5_and16_2"
            / "bitwise"
            / "diamond"
            / "lakeroad_lattice_ecp5_and16_2_prim.v",
            utils.output_dir()
            / "lattice_ecp5"
            / "lakeroad_lattice_ecp5_and32_2"
            / "bitwise"
            / "diamond"
            / "lakeroad_lattice_ecp5_and32_2_prim.v",
            utils.output_dir()
            / "lattice_ecp5"
            / "lakeroad_lattice_ecp5_eq1_2"
            / "comparison"
            / "diamond"
            / "lakeroad_lattice_ecp5_eq1_2_prim.v",
            utils.output_dir()
            / "lattice_ecp5"
            / "lakeroad_lattice_ecp5_eq5_2"
            / "comparison"
            / "diamond"
            / "lakeroad_lattice_ecp5_eq5_2_prim.v",
            utils.output_dir()
            / "lattice_ecp5"
            / "lakeroad_lattice_ecp5_eq6_2"
            / "comparison"
            / "diamond"
            / "lakeroad_lattice_ecp5_eq6_2_prim.v",
            utils.output_dir()
            / "lattice_ecp5"
            / "lakeroad_lattice_ecp5_eq32_2"
            / "comparison"
            / "diamond"
            / "lakeroad_lattice_ecp5_eq32_2_prim.v",
            utils.output_dir()
            / "lattice_ecp5"
            / "lakeroad_lattice_ecp5_neq1_2"
            / "comparison"
            / "diamond"
            / "lakeroad_lattice_ecp5_neq1_2_prim.v",
            utils.output_dir()
            / "lattice_ecp5"
            / "lakeroad_lattice_ecp5_not1_1"
            / "bitwise"
            / "diamond"
            / "lakeroad_lattice_ecp5_not1_1_prim.v",
            utils.output_dir()
            / "lattice_ecp5"
            / "lakeroad_lattice_ecp5_not5_1"
            / "bitwise"
            / "diamond"
            / "lakeroad_lattice_ecp5_not5_1_prim.v",
            utils.output_dir()
            / "lattice_ecp5"
            / "lakeroad_lattice_ecp5_or1_2"
            / "bitwise"
            / "diamond"
            / "lakeroad_lattice_ecp5_or1_2_prim.v",
            utils.output_dir()
            / "lattice_ecp5"
            / "lakeroad_lattice_ecp5_or8_2"
            / "bitwise"
            / "diamond"
            / "lakeroad_lattice_ecp5_or8_2_prim.v",
            utils.output_dir()
            / "lattice_ecp5"
            / "lakeroad_lattice_ecp5_sub1_2"
            / "bitwise-with-carry"
            / "diamond"
            / "lakeroad_lattice_ecp5_sub1_2_prim.v",
            utils.output_dir()
            / "lattice_ecp5"
            / "lakeroad_lattice_ecp5_sub2_2"
            / "bitwise-with-carry"
            / "diamond"
            / "lakeroad_lattice_ecp5_sub2_2_prim.v",
            utils.output_dir()
            / "lattice_ecp5"
            / "lakeroad_lattice_ecp5_sub3_2"
            / "bitwise-with-carry"
            / "diamond"
            / "lakeroad_lattice_ecp5_sub3_2_prim.v",
            utils.output_dir()
            / "lattice_ecp5"
            / "lakeroad_lattice_ecp5_sub4_2"
            / "bitwise-with-carry"
            / "diamond"
            / "lakeroad_lattice_ecp5_sub4_2_prim.v",
            utils.output_dir()
            / "lattice_ecp5"
            / "lakeroad_lattice_ecp5_sub5_2"
            / "bitwise-with-carry"
            / "diamond"
            / "lakeroad_lattice_ecp5_sub5_2_prim.v",
            utils.output_dir()
            / "lattice_ecp5"
            / "lakeroad_lattice_ecp5_sub6_2"
            / "bitwise-with-carry"
            / "diamond"
            / "lakeroad_lattice_ecp5_sub6_2_prim.v",
            utils.output_dir()
            / "lattice_ecp5"
            / "lakeroad_lattice_ecp5_sub7_2"
            / "bitwise-with-carry"
            / "diamond"
            / "lakeroad_lattice_ecp5_sub7_2_prim.v",
            utils.output_dir()
            / "lattice_ecp5"
            / "lakeroad_lattice_ecp5_sub8_2"
            / "bitwise-with-carry"
            / "diamond"
            / "lakeroad_lattice_ecp5_sub8_2_prim.v",
            utils.output_dir()
            / "lattice_ecp5"
            / "lakeroad_lattice_ecp5_sub16_2"
            / "bitwise-with-carry"
            / "diamond"
            / "lakeroad_lattice_ecp5_sub16_2_prim.v",
            utils.output_dir()
            / "lattice_ecp5"
            / "lakeroad_lattice_ecp5_sub32_2"
            / "bitwise-with-carry"
            / "diamond"
            / "lakeroad_lattice_ecp5_sub32_2_prim.v",
            utils.output_dir()
            / "lattice_ecp5"
            / "lakeroad_lattice_ecp5_uge1_2"
            / "comparison"
            / "diamond"
            / "lakeroad_lattice_ecp5_uge1_2_prim.v",
            utils.output_dir()
            / "lattice_ecp5"
            / "lakeroad_lattice_ecp5_ugt1_2"
            / "comparison"
            / "diamond"
            / "lakeroad_lattice_ecp5_ugt1_2_prim.v",
            utils.output_dir()
            / "lattice_ecp5"
            / "lakeroad_lattice_ecp5_ugt5_2"
            / "comparison"
            / "diamond"
            / "lakeroad_lattice_ecp5_ugt5_2_prim.v",
            utils.output_dir()
            / "lattice_ecp5"
            / "lakeroad_lattice_ecp5_ule1_2"
            / "comparison"
            / "diamond"
            / "lakeroad_lattice_ecp5_ule1_2_prim.v",
            utils.output_dir()
            / "lattice_ecp5"
            / "lakeroad_lattice_ecp5_ule4_2"
            / "comparison"
            / "diamond"
            / "lakeroad_lattice_ecp5_ule4_2_prim.v",
            utils.output_dir()
            / "lattice_ecp5"
            / "lakeroad_lattice_ecp5_ult1_2"
            / "comparison"
            / "diamond"
            / "lakeroad_lattice_ecp5_ult1_2_prim.v",
            utils.output_dir()
            / "lattice_ecp5"
            / "lakeroad_lattice_ecp5_ult3_2"
            / "comparison"
            / "diamond"
            / "lakeroad_lattice_ecp5_ult3_2_prim.v",
            utils.output_dir()
            / "lattice_ecp5"
            / "lakeroad_lattice_ecp5_ult4_2"
            / "comparison"
            / "diamond"
            / "lakeroad_lattice_ecp5_ult4_2_prim.v",
            utils.output_dir()
            / "lattice_ecp5"
            / "lakeroad_lattice_ecp5_ult32_2"
            / "comparison"
            / "diamond"
            / "lakeroad_lattice_ecp5_ult32_2_prim.v",
        ],
        calyx_dirpath=(utils.lakeroad_evaluation_dir() / "calyx-lattice-ecp5"),
    )


def task_calyx_tests_lattice_ecp5_lakeroad():
    """Run Calyx tests for calyx-lattice-ecp5 directory."""
    return _make_run_calyx_tests_task(
        calyx_dirpath=(utils.lakeroad_evaluation_dir() / "calyx-lattice-ecp5"),
        log_filepath=(utils.output_dir() / "lattice_ecp5_lakeroad_calyx_tests.log"),
        setup_calyx_taskname="calyx_setup_lattice_ecp5_lakeroad",
    )


def task_calyx_end_to_end_lattice_ecp5_lakeroad():
    """Run end-to-end tests for calyx-lattice-ecp5."""
    return _make_calyx_end_to_end_task(
        calyx_dirpath=(utils.lakeroad_evaluation_dir() / "calyx-lattice-ecp5"),
        output_base_dirpath=(
            utils.output_dir() / "calyx_lattice_ecp5_lakeroad_end_to_end"
        ),
        make_synthesis_task_fn=make_lattice_ecp5_diamond_synthesis_task,
        setup_calyx_taskname="calyx_setup_lattice_ecp5_lakeroad",
    )
