import utils
import logging
import os
from pathlib import Path
import subprocess
from typing import Dict, Iterable, Optional, Union
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

    TODO(@gussmith23): Currently, this copies everything into core.sv. This just
    happens to make things work because core.sv is copied into every file
    compiled through Calyx. However, some stuff doesn't actually belong in
    core.sv (e.g. sqrt, from math.sv). This may or may not be an issue; it's
    mostly just messy.

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


def _get_futil_files_to_test_with():
    """Generates the list of Calyx files that we use for end-to-end tests."""
    return (
        list(
            (
                utils.lakeroad_evaluation_dir()
                / "benchmarks"
                / "calyx_tests"
                / "correctness"
                / "exp"
            ).glob("**/*.futil")
        )
        + list(
            (
                utils.lakeroad_evaluation_dir()
                / "benchmarks"
                / "calyx_tests"
                / "correctness"
                / "ntt-pipeline"
            ).glob("**/*.futil")
        )
        + list(
            (
                utils.lakeroad_evaluation_dir()
                / "benchmarks"
                / "calyx_tests"
                / "correctness"
                / "numeric-types"
            ).glob("**/*.futil")
        )
        # + list((utils.lakeroad_evaluation_dir() / "benchmarks" / "calyx_tests"  / "correctness" / "ref-cells").glob("**/*.futil"))
        + list(
            (
                utils.lakeroad_evaluation_dir()
                / "benchmarks"
                / "calyx_tests"
                / "correctness"
                / "relay"
            ).glob("**/*.futil")
        )
        + list(
            (
                utils.lakeroad_evaluation_dir()
                / "benchmarks"
                / "calyx_tests"
                / "correctness"
                / "systolic"
            ).glob("**/*.futil")
        )
        # Disabling these tests as they cause the following error when
        # synthesized via Diamond:
        # ERROR - synthesis: Multiple Non-Tristate drivers exist for net clk.
        # They work fine via Vivado.
        # + list((calyx_dirpath / "tests" / "correctness" / "tcam").glob("**/*.futil"))
        + list(
            (utils.lakeroad_evaluation_dir() / "benchmarks" / "calyx_evaluation").glob(
                "**/*.fuse"
            )
        )
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
    clock_info_map: Dict[str, Tuple[str, float]],
    setup_calyx_taskname: Optional[str] = None,
):
    """
    Args:
      clock_info_map: Maps a benchmark (identified by its filepath as a str) to
        (clock_name, clock_period)."""

    calyx_dirpath = Path(calyx_dirpath)
    output_base_dirpath = Path(output_base_dirpath)

    for futil_filepath in _get_futil_files_to_test_with():
        relative_dir_in_eval_repo = futil_filepath.parent.relative_to(
            utils.lakeroad_evaluation_dir()
        )
        compiled_sv_filepath = (
            output_base_dirpath
            / "compiled_with_futil"
            / relative_dir_in_eval_repo
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

        clock_info = clock_info_map[
            str(futil_filepath.relative_to(utils.lakeroad_evaluation_dir()))
        ]

        synthesis_task = make_synthesis_task_fn(
            input_filepath=compiled_sv_filepath,
            output_dirpath=output_base_dirpath
            / "synthesis_results"
            / relative_dir_in_eval_repo
            / futil_filepath.name,
            module_name="main",
            clock_info=clock_info,
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
            utils.output_dir() / "baseline" / "vivado" / "and4_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "and8_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "and16_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "and32_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "eq1_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "eq4_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "eq5_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "eq6_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "eq32_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "neq1_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "neq32_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "not1_1.sv",
            utils.output_dir() / "baseline" / "vivado" / "not5_1.sv",
            utils.output_dir() / "baseline" / "vivado" / "or1_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "or8_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "seq_mem_d1_32_2_3.sv",
            utils.output_dir() / "baseline" / "vivado" / "seq_mem_d1_32_4_4.sv",
            utils.output_dir() / "baseline" / "vivado" / "seq_mem_d1_32_6_4.sv",
            utils.output_dir() / "baseline" / "vivado" / "seq_mem_d1_32_8_5.sv",
            utils.output_dir() / "baseline" / "vivado" / "seq_mem_d1_32_16_4.sv",
            utils.output_dir() / "baseline" / "vivado" / "seq_mem_d1_32_64_8.sv",
            utils.output_dir() / "baseline" / "vivado" / "seq_mem_d1_32_96_8.sv",
            utils.output_dir() / "baseline" / "vivado" / "seq_mem_d1_32_1_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "seq_mem_d1_32_8_4.sv",
            utils.output_dir() / "baseline" / "vivado" / "seq_mem_d1_32_144_8.sv",
            utils.output_dir() / "baseline" / "vivado" / "shru4_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "std_reg_1.sv",
            utils.output_dir() / "baseline" / "vivado" / "std_reg_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "std_reg_3.sv",
            utils.output_dir() / "baseline" / "vivado" / "std_reg_4.sv",
            utils.output_dir() / "baseline" / "vivado" / "std_reg_5.sv",
            utils.output_dir() / "baseline" / "vivado" / "std_reg_6.sv",
            utils.output_dir() / "baseline" / "vivado" / "std_reg_7.sv",
            utils.output_dir() / "baseline" / "vivado" / "std_reg_32.sv",
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
            utils.output_dir() / "baseline" / "vivado" / "uge4_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "ugt1_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "ugt5_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "ule1_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "ule4_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "ult1_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "ult2_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "ult3_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "ult4_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "ult32_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "fp_sqrt_32_32_0.sv",
            utils.output_dir() / "baseline" / "vivado" / "fp_sqrt_32_16_16.sv",
            utils.output_dir() / "baseline" / "vivado" / "std_fp_add_32_16_16.sv",
            utils.output_dir() / "baseline" / "vivado" / "std_fp_add_32_1_31.sv",
            utils.output_dir() / "baseline" / "vivado" / "std_fp_sub_32_16_16.sv",
            utils.output_dir() / "baseline" / "vivado" / "std_fp_sub_32_1_31.sv",
            utils.output_dir()
            / "baseline"
            / "vivado"
            / "std_fp_mult_pipe_32_16_16_0.sv",
            utils.output_dir()
            / "baseline"
            / "vivado"
            / "std_fp_mult_pipe_32_16_16_1.sv",
            utils.output_dir()
            / "baseline"
            / "vivado"
            / "std_fp_mult_pipe_32_32_0_0.sv",
            utils.output_dir()
            / "baseline"
            / "vivado"
            / "std_fp_mult_pipe_32_32_0_1.sv",
            utils.output_dir()
            / "baseline"
            / "vivado"
            / "std_fp_mult_pipe_32_1_31_0.sv",
            utils.output_dir() / "baseline" / "vivado" / "std_fp_mult_pipe_4_2_2_1.sv",
            utils.output_dir() / "baseline" / "vivado" / "std_fp_mult_pipe_4_4_0_1.sv",
            utils.output_dir() / "baseline" / "vivado" / "std_fp_div_pipe_32_16_16.sv",
            utils.output_dir() / "baseline" / "vivado" / "std_fp_div_pipe_32_1_31.sv",
            utils.output_dir() / "baseline" / "vivado" / "std_fp_div_pipe_4_2_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "std_fp_div_pipe_32_24_8.sv",
            utils.output_dir() / "baseline" / "vivado" / "sadd4_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "sadd32_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "ssub4_2.sv",
            utils.output_dir() / "baseline" / "vivado" / "ssub32_2.sv",
        ],
        calyx_dirpath=(utils.lakeroad_evaluation_dir() / "calyx_vivado"),
    )


def task_calyx_tests_xilinx_ultrascale_plus_presynth_vivado():
    """Run Calyx tests for calyx_vivado."""
    return _make_run_calyx_tests_task(
        calyx_dirpath=(utils.lakeroad_evaluation_dir() / "calyx_vivado"),
        log_filepath=(
            utils.output_dir() / "xilinx_ultrascale_plus_vivado_calyx_tests.log"
        ),
        setup_calyx_taskname="calyx_setup_xilinx_ultrascale_plus_vivado",
    )


# Sets the clock periods for the Calyx E2E presynth w/ Vivado experiments.
#
# TODO(@gussmith23): These should be moved to config files. One important
# reason: currently, if these change, DoIt will not rerun evaluation unless told
# to. If they were in a file, it would be easier to make them a DoIt dependency.
calyx_end_to_end_xilinx_ultrascale_plus_presynth_vivado_clock_info_map = {
    "benchmarks/calyx_evaluation/polybench/linear-algebra-2mm.fuse": ("clk", 4.241),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-3mm.fuse": ("clk", 3.692),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-atax.fuse": ("clk", 3.605),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-bicg.fuse": ("clk", 2.926),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-cholesky.fuse": (
        "clk",
        3.492,
    ),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-doitgen.fuse": ("clk", 2.953),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-durbin.fuse": ("clk", 4.269),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-gemm.fuse": ("clk", 3.695),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-gemver.fuse": ("clk", 4.327),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-gesummv.fuse": ("clk", 4.066),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-gramschmidt.fuse": (
        "clk",
        4.349,
    ),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-lu.fuse": ("clk", 3.886),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-ludcmp.fuse": ("clk", 4.25),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-mvt.fuse": ("clk", 3.884),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-symm.fuse": ("clk", 3.9),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-syr2k.fuse": ("clk", 3.753),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-syrk.fuse": ("clk", 4.122),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-trisolv.fuse": ("clk", 2.805),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-trmm.fuse": ("clk", 2.873),
    "benchmarks/calyx_evaluation/systolic-sources/gemm2.fuse": ("clk", 4.303),
    "benchmarks/calyx_evaluation/systolic-sources/gemm4.fuse": ("clk", 5.078),
    "benchmarks/calyx_evaluation/systolic-sources/gemm6.fuse": ("clk", 5.73),
    "benchmarks/calyx_evaluation/systolic-sources/gemm8.fuse": ("clk", 6.626),
    "benchmarks/calyx_tests/correctness/numeric-types/bitnum/binary-operators.futil": (
        "clk",
        2.8,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/bitnum/sqrt.futil": (
        "clk",
        1.847,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/bitnum/std-sdiv.futil": (
        "clk",
        3.404,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/fixed-point/binary-operators.futil": (
        "clk",
        3.044,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/fixed-point/sqrt.futil": (
        "clk",
        1.954,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/fixed-point/std-fp-sdiv.futil": (
        "clk",
        3.566,
    ),
}


def task_calyx_end_to_end_xilinx_ultrascale_plus_presynth_vivado_iter0():
    """End-to-end Calyx experiments.

    Synthesize benchmarks with using Calyx with primitives presynthesized for
    Xilinx UltraScale+ using Vivado (iteration 2)."""
    return _make_calyx_end_to_end_task(
        calyx_dirpath=(utils.lakeroad_evaluation_dir() / "calyx_vivado"),
        output_base_dirpath=(
            utils.output_dir()
            / "calyx_end_to_end_xilinx_ultrascale_plus_presynth_vivado"
            / "iter0"
        ),
        # Use the synthesis function which does not perform optimization, and is
        # optimized for runtime. This is because the pre-synthesized
        # instructions will have already been synthesized with optimizations on.
        make_synthesis_task_fn=make_xilinx_ultrascale_plus_vivado_synthesis_task_noopt,
        setup_calyx_taskname="calyx_setup_xilinx_ultrascale_plus_vivado",
        clock_info_map=calyx_end_to_end_xilinx_ultrascale_plus_presynth_vivado_clock_info_map,
    )


def task_calyx_end_to_end_xilinx_ultrascale_plus_presynth_vivado_iter1():
    """End-to-end Calyx experiments.

    Synthesize benchmarks with using Calyx with primitives presynthesized for
    Xilinx UltraScale+ using Vivado (iteration 2)."""
    return _make_calyx_end_to_end_task(
        calyx_dirpath=(utils.lakeroad_evaluation_dir() / "calyx_vivado"),
        output_base_dirpath=(
            utils.output_dir()
            / "calyx_end_to_end_xilinx_ultrascale_plus_presynth_vivado"
            / "iter1"
        ),
        # Use the synthesis function which does not perform optimization, and is
        # optimized for runtime. This is because the pre-synthesized
        # instructions will have already been synthesized with optimizations on.
        make_synthesis_task_fn=make_xilinx_ultrascale_plus_vivado_synthesis_task_noopt,
        setup_calyx_taskname="calyx_setup_xilinx_ultrascale_plus_vivado",
        clock_info_map=calyx_end_to_end_xilinx_ultrascale_plus_presynth_vivado_clock_info_map,
    )


def task_calyx_end_to_end_xilinx_ultrascale_plus_presynth_vivado_iter2():
    """End-to-end Calyx experiments.

    Synthesize benchmarks with using Calyx with primitives presynthesized for
    Xilinx UltraScale+ using Vivado (iteration 2)."""
    return _make_calyx_end_to_end_task(
        calyx_dirpath=(utils.lakeroad_evaluation_dir() / "calyx_vivado"),
        output_base_dirpath=(
            utils.output_dir()
            / "calyx_end_to_end_xilinx_ultrascale_plus_presynth_vivado"
            / "iter2"
        ),
        # Use the synthesis function which does not perform optimization, and is
        # optimized for runtime. This is because the pre-synthesized
        # instructions will have already been synthesized with optimizations on.
        make_synthesis_task_fn=make_xilinx_ultrascale_plus_vivado_synthesis_task_noopt,
        setup_calyx_taskname="calyx_setup_xilinx_ultrascale_plus_vivado",
        clock_info_map=calyx_end_to_end_xilinx_ultrascale_plus_presynth_vivado_clock_info_map,
    )


def task_calyx_end_to_end_xilinx_ultrascale_plus_presynth_vivado_nosynth_experiment():
    """End-to-end Calyx experiments.

    Experimental. Tries to make synthesis as minimal as possible."""
    return _make_calyx_end_to_end_task(
        calyx_dirpath=(utils.lakeroad_evaluation_dir() / "calyx_vivado"),
        output_base_dirpath=(
            utils.output_dir()
            / "calyx_end_to_end_xilinx_ultrascale_plus_presynth_vivado_nosynth_experiment"
        ),
        # Use the synthesis function which does not perform optimization, and is
        # optimized for runtime. This is because the pre-synthesized
        # instructions will have already been synthesized with optimizations on.
        make_synthesis_task_fn=make_xilinx_ultrascale_plus_vivado_synthesis_task_nosynth,
        setup_calyx_taskname="calyx_setup_xilinx_ultrascale_plus_vivado",
        clock_info_map=calyx_end_to_end_xilinx_ultrascale_plus_presynth_vivado_clock_info_map,
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


calyx_end_to_end_lattice_ecp5_diamond_clock_info_map = {
    "benchmarks/calyx_tests/correctness/numeric-types/fixed-point/constants.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/fixed-point/std-fp-sdiv.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/fixed-point/binary-operators.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/fixed-point/sqrt.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/parsing/unsigned-fp.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/parsing/signed-bitnum.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/parsing/signed-fp.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/parsing/unsigned-bitnum.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/bitnum/std-sdiv.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/bitnum/binary-operators.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/bitnum/sqrt.futil": ("clk", 7.0),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-syr2k.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-2mm.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-gemm.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-gramschmidt.fuse": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-gemver.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-doitgen.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-3mm.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-syrk.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-gesummv.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-atax.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-lu.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-bicg.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-syr2k.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-2mm.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-gemm.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-gramschmidt.fuse": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-durbin.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-mvt.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-gemver.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-ludcmp.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-trmm.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-doitgen.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-trisolv.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-symm.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-cholesky.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-3mm.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-syrk.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-gesummv.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-atax.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/systolic-sources/gemm8.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/systolic-sources/gemm6.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/systolic-sources/gemm4.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/systolic-sources/gemm2.fuse": ("clk", 7.0),
}


def task_calyx_end_to_end_lattice_ecp5_diamond():
    """Run end-to-end tests for calyx_lattice_ecp5_diamond."""
    return _make_calyx_end_to_end_task(
        calyx_dirpath=(utils.lakeroad_evaluation_dir() / "calyx_lattice_ecp5_diamond"),
        output_base_dirpath=(
            utils.output_dir() / "calyx_lattice_ecp5_diamond_end_to_end"
        ),
        make_synthesis_task_fn=make_lattice_ecp5_diamond_synthesis_task,
        setup_calyx_taskname="calyx_setup_lattice_ecp5_diamond",
        clock_info_map=calyx_end_to_end_lattice_ecp5_diamond_clock_info_map,
    )


def task_calyx_tests_vanilla_calyx():
    """Run Calyx tests for vanilla Calyx."""
    return _make_run_calyx_tests_task(
        calyx_dirpath=(utils.lakeroad_evaluation_dir() / "calyx"),
        log_filepath=(utils.output_dir() / "vanilla_calyx_tests.log"),
    )


calyx_end_to_end_xilinx_ultrascale_plus_no_presynth_clock_info_map = {
    "benchmarks/calyx_evaluation/polybench/linear-algebra-2mm.fuse": ("clk", 3.919),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-3mm.fuse": ("clk", 3.933),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-atax.fuse": ("clk", 3.705),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-bicg.fuse": ("clk", 2.888),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-cholesky.fuse": (
        "clk",
        3.162,
    ),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-doitgen.fuse": ("clk", 2.91),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-durbin.fuse": ("clk", 3.622),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-gemm.fuse": ("clk", 3.124),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-gemver.fuse": ("clk", 4.729),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-gesummv.fuse": ("clk", 3.632),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-gramschmidt.fuse": (
        "clk",
        3.798,
    ),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-lu.fuse": ("clk", 3.327),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-ludcmp.fuse": ("clk", 3.681),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-mvt.fuse": ("clk", 3.461),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-symm.fuse": ("clk", 2.949),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-syr2k.fuse": ("clk", 3.184),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-syrk.fuse": ("clk", 2.955),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-trisolv.fuse": ("clk", 2.805),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-trmm.fuse": ("clk", 2.779),
    "benchmarks/calyx_evaluation/systolic-sources/gemm2.fuse": ("clk", 3.482),
    "benchmarks/calyx_evaluation/systolic-sources/gemm4.fuse": ("clk", 4.341),
    "benchmarks/calyx_evaluation/systolic-sources/gemm6.fuse": ("clk", 6.055),
    "benchmarks/calyx_evaluation/systolic-sources/gemm8.fuse": ("clk", 5.812),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-2mm.fuse": ("clk", 4.987),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-3mm.fuse": ("clk", 5.768),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-atax.fuse": ("clk", 4.101),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-doitgen.fuse": ("clk", 4.16),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-gemm.fuse": ("clk", 4.631),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-gemver.fuse": ("clk", 5.912),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-gesummv.fuse": ("clk", 4.57),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-gramschmidt.fuse": (
        "clk",
        5.545,
    ),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-syr2k.fuse": ("clk", 3.956),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-syrk.fuse": ("clk", 3.78),
    "benchmarks/calyx_tests/correctness/numeric-types/bitnum/binary-operators.futil": (
        "clk",
        2.779,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/bitnum/sqrt.futil": (
        "clk",
        1.815,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/bitnum/std-sdiv.futil": (
        "clk",
        2.667,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/fixed-point/binary-operators.futil": (
        "clk",
        2.981,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/fixed-point/constants.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/fixed-point/sqrt.futil": (
        "clk",
        2.028,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/fixed-point/std-fp-sdiv.futil": (
        "clk",
        3.834,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/parsing/signed-bitnum.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/parsing/signed-fp.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/parsing/unsigned-bitnum.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/parsing/unsigned-fp.futil": (
        "clk",
        7.0,
    ),
}


def task_calyx_end_to_end_xilinx_ultrascale_plus_no_presynth_iter0():
    """End-to-end Calyx experiments.

    Tests unmodified Calyx (i.e. no presynthesis), synthesizing its output with
    Vivado."""
    return _make_calyx_end_to_end_task(
        calyx_dirpath=(utils.lakeroad_evaluation_dir() / "calyx"),
        output_base_dirpath=utils.output_dir()
        / "calyx_end_to_end_xilinx_ultrascale_plus_no_presynth"
        / "iter0",
        # Run optimization with synthesis.
        make_synthesis_task_fn=make_xilinx_ultrascale_plus_vivado_synthesis_task_opt,
        clock_info_map=calyx_end_to_end_xilinx_ultrascale_plus_no_presynth_clock_info_map,
    )


def task_calyx_end_to_end_xilinx_ultrascale_plus_no_presynth_iter1():
    """End-to-end Calyx experiments.

    Tests unmodified Calyx (i.e. no presynthesis), synthesizing its output with
    Vivado."""
    return _make_calyx_end_to_end_task(
        calyx_dirpath=(utils.lakeroad_evaluation_dir() / "calyx"),
        output_base_dirpath=utils.output_dir()
        / "calyx_end_to_end_xilinx_ultrascale_plus_no_presynth"
        / "iter1",
        # Run optimization with synthesis.
        make_synthesis_task_fn=make_xilinx_ultrascale_plus_vivado_synthesis_task_opt,
        clock_info_map=calyx_end_to_end_xilinx_ultrascale_plus_no_presynth_clock_info_map,
    )


def task_calyx_end_to_end_xilinx_ultrascale_plus_no_presynth_iter2():
    """End-to-end Calyx experiments.

    Tests unmodified Calyx (i.e. no presynthesis), synthesizing its output with
    Vivado."""
    return _make_calyx_end_to_end_task(
        calyx_dirpath=(utils.lakeroad_evaluation_dir() / "calyx"),
        output_base_dirpath=utils.output_dir()
        / "calyx_end_to_end_xilinx_ultrascale_plus_no_presynth"
        / "iter2",
        # Run optimization with synthesis.
        make_synthesis_task_fn=make_xilinx_ultrascale_plus_vivado_synthesis_task_opt,
        clock_info_map=calyx_end_to_end_xilinx_ultrascale_plus_no_presynth_clock_info_map,
    )


vanilla_calyx_end_to_end_lattice_ecp5_diamond_clock_info_map = {
    "benchmarks/calyx_tests/correctness/numeric-types/fixed-point/constants.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/fixed-point/std-fp-sdiv.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/fixed-point/binary-operators.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/fixed-point/sqrt.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/parsing/unsigned-fp.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/parsing/signed-bitnum.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/parsing/signed-fp.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/parsing/unsigned-bitnum.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/bitnum/std-sdiv.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/bitnum/binary-operators.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/bitnum/sqrt.futil": ("clk", 7.0),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-syr2k.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-2mm.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-gemm.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-gramschmidt.fuse": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-gemver.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-doitgen.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-3mm.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-syrk.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-gesummv.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-atax.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-lu.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-bicg.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-syr2k.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-2mm.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-gemm.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-gramschmidt.fuse": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-durbin.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-mvt.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-gemver.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-ludcmp.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-trmm.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-doitgen.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-trisolv.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-symm.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-cholesky.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-3mm.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-syrk.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-gesummv.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-atax.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/systolic-sources/gemm8.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/systolic-sources/gemm6.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/systolic-sources/gemm4.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/systolic-sources/gemm2.fuse": ("clk", 7.0),
}


def task_vanilla_calyx_end_to_end_lattice_ecp5_diamond():
    """Run end-to-end tests for vanilla Calyx, synthesizing with Diamond."""
    return _make_calyx_end_to_end_task(
        calyx_dirpath=(utils.lakeroad_evaluation_dir() / "calyx"),
        output_base_dirpath=(utils.output_dir() / "vanilla_calyx_diamond_end_to_end"),
        make_synthesis_task_fn=make_lattice_ecp5_diamond_synthesis_task,
        clock_info_map=vanilla_calyx_end_to_end_lattice_ecp5_diamond_clock_info_map,
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


calyx_end_to_end_lattice_ecp5_lakeroad_clock_info_map = {
    "benchmarks/calyx_tests/correctness/numeric-types/fixed-point/constants.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/fixed-point/std-fp-sdiv.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/fixed-point/binary-operators.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/fixed-point/sqrt.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/parsing/unsigned-fp.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/parsing/signed-bitnum.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/parsing/signed-fp.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/parsing/unsigned-bitnum.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/bitnum/std-sdiv.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/bitnum/binary-operators.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/bitnum/sqrt.futil": ("clk", 7.0),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-syr2k.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-2mm.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-gemm.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-gramschmidt.fuse": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-gemver.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-doitgen.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-3mm.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-syrk.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-gesummv.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-atax.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-lu.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-bicg.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-syr2k.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-2mm.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-gemm.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-gramschmidt.fuse": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-durbin.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-mvt.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-gemver.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-ludcmp.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-trmm.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-doitgen.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-trisolv.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-symm.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-cholesky.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-3mm.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-syrk.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-gesummv.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-atax.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/systolic-sources/gemm8.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/systolic-sources/gemm6.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/systolic-sources/gemm4.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/systolic-sources/gemm2.fuse": ("clk", 7.0),
}


def task_calyx_end_to_end_lattice_ecp5_lakeroad():
    """Run end-to-end tests for calyx-lattice-ecp5."""
    return _make_calyx_end_to_end_task(
        calyx_dirpath=(utils.lakeroad_evaluation_dir() / "calyx-lattice-ecp5"),
        output_base_dirpath=(
            utils.output_dir() / "calyx_lattice_ecp5_lakeroad_end_to_end"
        ),
        make_synthesis_task_fn=make_lattice_ecp5_diamond_synthesis_task,
        setup_calyx_taskname="calyx_setup_lattice_ecp5_lakeroad",
        clock_info_map=calyx_end_to_end_lattice_ecp5_lakeroad_clock_info_map,
    )


def task_calyx_setup_xilinx_ultrascale_plus_lakeroad():
    """Set up the calyx-xilinx-ultrascale-plus directory.

    This is the version of Calyx with instructions pre-synthesized by Lakeroad.

    TODO(@gussmith23): Rename directory to include lakeroad."""
    return _make_setup_calyx_task(
        filepaths=[
            utils.output_dir()
            / "xilinx_ultrascale_plus"
            / "lakeroad_xilinx_ultrascale_plus_add1_2"
            / "bitwise-with-carry"
            / "vivado"
            / "synth_opt_place_route.sv",
            utils.output_dir()
            / "xilinx_ultrascale_plus"
            / "lakeroad_xilinx_ultrascale_plus_add2_2"
            / "bitwise-with-carry"
            / "vivado"
            / "synth_opt_place_route.sv",
            utils.output_dir()
            / "xilinx_ultrascale_plus"
            / "lakeroad_xilinx_ultrascale_plus_add3_2"
            / "bitwise-with-carry"
            / "vivado"
            / "synth_opt_place_route.sv",
            utils.output_dir()
            / "xilinx_ultrascale_plus"
            / "lakeroad_xilinx_ultrascale_plus_add4_2"
            / "bitwise-with-carry"
            / "vivado"
            / "synth_opt_place_route.sv",
            utils.output_dir()
            / "xilinx_ultrascale_plus"
            / "lakeroad_xilinx_ultrascale_plus_add8_2"
            / "bitwise-with-carry"
            / "vivado"
            / "synth_opt_place_route.sv",
            utils.output_dir()
            / "xilinx_ultrascale_plus"
            / "lakeroad_xilinx_ultrascale_plus_add16_2"
            / "bitwise-with-carry"
            / "vivado"
            / "synth_opt_place_route.sv",
            utils.output_dir()
            / "xilinx_ultrascale_plus"
            / "lakeroad_xilinx_ultrascale_plus_add32_2"
            / "bitwise-with-carry"
            / "vivado"
            / "synth_opt_place_route.sv",
            utils.output_dir()
            / "xilinx_ultrascale_plus"
            / "lakeroad_xilinx_ultrascale_plus_and1_2"
            / "bitwise"
            / "vivado"
            / "synth_opt_place_route.sv",
            utils.output_dir()
            / "xilinx_ultrascale_plus"
            / "lakeroad_xilinx_ultrascale_plus_and2_2"
            / "bitwise"
            / "vivado"
            / "synth_opt_place_route.sv",
            utils.output_dir()
            / "xilinx_ultrascale_plus"
            / "lakeroad_xilinx_ultrascale_plus_and8_2"
            / "bitwise"
            / "vivado"
            / "synth_opt_place_route.sv",
            utils.output_dir()
            / "xilinx_ultrascale_plus"
            / "lakeroad_xilinx_ultrascale_plus_and16_2"
            / "bitwise"
            / "vivado"
            / "synth_opt_place_route.sv",
            utils.output_dir()
            / "xilinx_ultrascale_plus"
            / "lakeroad_xilinx_ultrascale_plus_and32_2"
            / "bitwise"
            / "vivado"
            / "synth_opt_place_route.sv",
            utils.output_dir()
            / "xilinx_ultrascale_plus"
            / "lakeroad_xilinx_ultrascale_plus_eq1_2"
            / "comparison"
            / "vivado"
            / "synth_opt_place_route.sv",
            utils.output_dir()
            / "xilinx_ultrascale_plus"
            / "lakeroad_xilinx_ultrascale_plus_eq5_2"
            / "comparison"
            / "vivado"
            / "synth_opt_place_route.sv",
            utils.output_dir()
            / "xilinx_ultrascale_plus"
            / "lakeroad_xilinx_ultrascale_plus_eq6_2"
            / "comparison"
            / "vivado"
            / "synth_opt_place_route.sv",
            utils.output_dir()
            / "xilinx_ultrascale_plus"
            / "lakeroad_xilinx_ultrascale_plus_eq32_2"
            / "comparison"
            / "vivado"
            / "synth_opt_place_route.sv",
            utils.output_dir()
            / "xilinx_ultrascale_plus"
            / "lakeroad_xilinx_ultrascale_plus_neq1_2"
            / "comparison"
            / "vivado"
            / "synth_opt_place_route.sv",
            utils.output_dir()
            / "xilinx_ultrascale_plus"
            / "lakeroad_xilinx_ultrascale_plus_not1_1"
            / "bitwise"
            / "vivado"
            / "synth_opt_place_route.sv",
            utils.output_dir()
            / "xilinx_ultrascale_plus"
            / "lakeroad_xilinx_ultrascale_plus_not5_1"
            / "bitwise"
            / "vivado"
            / "synth_opt_place_route.sv",
            utils.output_dir()
            / "xilinx_ultrascale_plus"
            / "lakeroad_xilinx_ultrascale_plus_or1_2"
            / "bitwise"
            / "vivado"
            / "synth_opt_place_route.sv",
            utils.output_dir()
            / "xilinx_ultrascale_plus"
            / "lakeroad_xilinx_ultrascale_plus_or8_2"
            / "bitwise"
            / "vivado"
            / "synth_opt_place_route.sv",
            utils.output_dir()
            / "xilinx_ultrascale_plus"
            / "lakeroad_xilinx_ultrascale_plus_sub1_2"
            / "bitwise-with-carry"
            / "vivado"
            / "synth_opt_place_route.sv",
            utils.output_dir()
            / "xilinx_ultrascale_plus"
            / "lakeroad_xilinx_ultrascale_plus_sub2_2"
            / "bitwise-with-carry"
            / "vivado"
            / "synth_opt_place_route.sv",
            utils.output_dir()
            / "xilinx_ultrascale_plus"
            / "lakeroad_xilinx_ultrascale_plus_sub3_2"
            / "bitwise-with-carry"
            / "vivado"
            / "synth_opt_place_route.sv",
            utils.output_dir()
            / "xilinx_ultrascale_plus"
            / "lakeroad_xilinx_ultrascale_plus_sub4_2"
            / "bitwise-with-carry"
            / "vivado"
            / "synth_opt_place_route.sv",
            utils.output_dir()
            / "xilinx_ultrascale_plus"
            / "lakeroad_xilinx_ultrascale_plus_sub5_2"
            / "bitwise-with-carry"
            / "vivado"
            / "synth_opt_place_route.sv",
            utils.output_dir()
            / "xilinx_ultrascale_plus"
            / "lakeroad_xilinx_ultrascale_plus_sub6_2"
            / "bitwise-with-carry"
            / "vivado"
            / "synth_opt_place_route.sv",
            utils.output_dir()
            / "xilinx_ultrascale_plus"
            / "lakeroad_xilinx_ultrascale_plus_sub7_2"
            / "bitwise-with-carry"
            / "vivado"
            / "synth_opt_place_route.sv",
            utils.output_dir()
            / "xilinx_ultrascale_plus"
            / "lakeroad_xilinx_ultrascale_plus_sub8_2"
            / "bitwise-with-carry"
            / "vivado"
            / "synth_opt_place_route.sv",
            utils.output_dir()
            / "xilinx_ultrascale_plus"
            / "lakeroad_xilinx_ultrascale_plus_sub16_2"
            / "bitwise-with-carry"
            / "vivado"
            / "synth_opt_place_route.sv",
            utils.output_dir()
            / "xilinx_ultrascale_plus"
            / "lakeroad_xilinx_ultrascale_plus_sub32_2"
            / "bitwise-with-carry"
            / "vivado"
            / "synth_opt_place_route.sv",
            utils.output_dir()
            / "xilinx_ultrascale_plus"
            / "lakeroad_xilinx_ultrascale_plus_uge1_2"
            / "comparison"
            / "vivado"
            / "synth_opt_place_route.sv",
            utils.output_dir()
            / "xilinx_ultrascale_plus"
            / "lakeroad_xilinx_ultrascale_plus_ugt1_2"
            / "comparison"
            / "vivado"
            / "synth_opt_place_route.sv",
            utils.output_dir()
            / "xilinx_ultrascale_plus"
            / "lakeroad_xilinx_ultrascale_plus_ugt5_2"
            / "comparison"
            / "vivado"
            / "synth_opt_place_route.sv",
            utils.output_dir()
            / "xilinx_ultrascale_plus"
            / "lakeroad_xilinx_ultrascale_plus_ule1_2"
            / "comparison"
            / "vivado"
            / "synth_opt_place_route.sv",
            utils.output_dir()
            / "xilinx_ultrascale_plus"
            / "lakeroad_xilinx_ultrascale_plus_ule4_2"
            / "comparison"
            / "vivado"
            / "synth_opt_place_route.sv",
            utils.output_dir()
            / "xilinx_ultrascale_plus"
            / "lakeroad_xilinx_ultrascale_plus_ult1_2"
            / "comparison"
            / "vivado"
            / "synth_opt_place_route.sv",
            utils.output_dir()
            / "xilinx_ultrascale_plus"
            / "lakeroad_xilinx_ultrascale_plus_ult3_2"
            / "comparison"
            / "vivado"
            / "synth_opt_place_route.sv",
            utils.output_dir()
            / "xilinx_ultrascale_plus"
            / "lakeroad_xilinx_ultrascale_plus_ult4_2"
            / "comparison"
            / "vivado"
            / "synth_opt_place_route.sv",
            utils.output_dir()
            / "xilinx_ultrascale_plus"
            / "lakeroad_xilinx_ultrascale_plus_ult32_2"
            / "comparison"
            / "vivado"
            / "synth_opt_place_route.sv",
        ],
        calyx_dirpath=(
            utils.lakeroad_evaluation_dir() / "calyx-xilinx-ultrascale-plus"
        ),
    )


def task_calyx_tests_xilinx_ultrascale_plus_lakeroad():
    """Run Calyx tests for calyx-xilinx-ultrascale-plus directory."""
    return _make_run_calyx_tests_task(
        calyx_dirpath=(
            utils.lakeroad_evaluation_dir() / "calyx-xilinx-ultrascale-plus"
        ),
        log_filepath=(
            utils.output_dir() / "xilinx_ultrascale_plus_lakeroad_calyx_tests.log"
        ),
        setup_calyx_taskname="calyx_setup_xilinx_ultrascale_plus_lakeroad",
    )


calyx_end_to_end_xilinx_ultrascale_plus_lakeroad_clock_info_map = {
    "benchmarks/calyx_tests/correctness/numeric-types/fixed-point/constants.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/fixed-point/std-fp-sdiv.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/fixed-point/binary-operators.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/fixed-point/sqrt.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/parsing/unsigned-fp.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/parsing/signed-bitnum.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/parsing/signed-fp.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/parsing/unsigned-bitnum.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/bitnum/std-sdiv.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/bitnum/binary-operators.futil": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_tests/correctness/numeric-types/bitnum/sqrt.futil": ("clk", 7.0),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-syr2k.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-2mm.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-gemm.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-gramschmidt.fuse": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-gemver.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-doitgen.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-3mm.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-syrk.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-gesummv.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/unrolled/linear-algebra-atax.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-lu.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-bicg.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-syr2k.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-2mm.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-gemm.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-gramschmidt.fuse": (
        "clk",
        7.0,
    ),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-durbin.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-mvt.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-gemver.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-ludcmp.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-trmm.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-doitgen.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-trisolv.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-symm.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-cholesky.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-3mm.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-syrk.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-gesummv.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/polybench/linear-algebra-atax.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/systolic-sources/gemm8.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/systolic-sources/gemm6.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/systolic-sources/gemm4.fuse": ("clk", 7.0),
    "benchmarks/calyx_evaluation/systolic-sources/gemm2.fuse": ("clk", 7.0),
}


def task_calyx_end_to_end_xilinx_ultrascale_plus_lakeroad():
    """Run end-to-end tests for calyx-xilinx-ultrascale-plus."""
    return _make_calyx_end_to_end_task(
        calyx_dirpath=(
            utils.lakeroad_evaluation_dir() / "calyx-xilinx-ultrascale-plus"
        ),
        output_base_dirpath=(
            utils.output_dir() / "calyx_xilinx_ultrascale_plus_lakeroad_end_to_end"
        ),
        # Synthesize without optimization, as the pre-synthesized instructions
        # should be considered optimized.
        make_synthesis_task_fn=make_xilinx_ultrascale_plus_vivado_synthesis_task_noopt,
        setup_calyx_taskname="calyx_setup_xilinx_ultrascale_plus_lakeroad",
        clock_info_map=calyx_end_to_end_xilinx_ultrascale_plus_lakeroad_clock_info_map,
    )
