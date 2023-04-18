import json
from pathlib import Path
from typing import List, Union
import numpy as np
import pandas
from lakeroad import make_lakeroad_task
import utils
import itertools
import hardware_compilation
import verilator
import quartus


def _collect_dsp_benchmark_data(
    filepaths: List[Union[str, Path]], output_filepath: Union[str, Path]
):
    """Collect DSP benchmark results into a file, but do not process them."""
    Path(output_filepath).parent.mkdir(parents=True, exist_ok=True)
    pandas.DataFrame.from_records(map(lambda f: json.load(open(f)), filepaths)).to_csv(
        output_filepath, index=False
    )


def _clean_dsp_benchmark_data(
    in_filepath: Union[str, Path],
    out_filepath: Union[str, Path],
):
    """Process DSP benchmark results.

    - Collapse multiple iterations into one.
    - Remove unnecessary columns."""

    df = pandas.read_csv(in_filepath)

    # Make archirtecture consistent.
    df.architecture.replace(
        "xilinx-ultrascale-plus", "xilinx_ultrascale_plus", inplace=True
    )
    df.architecture.replace("lattice-ecp5", "lattice_ecp5", inplace=True)

    def _assert_one(df: pandas.Series):
        assert type(df) == pandas.Series
        assert df.count() == 1, f"Expected only one value in {df}"
        return df.dropna().unique()[0]

    # Combine LUT columns.
    df["luts"] = (
        df["clb_luts"].fillna(0) + df["num_LUT4"].fillna(0) + df["LUT2"].fillna(0)
    )

    # Combine carry columns.
    df["carries"] = df["carry8s"].fillna(0) + df["CARRY4"].fillna(0)

    # Combine mux columns.
    df["muxes"] = (
        df["num_PFUMX"].fillna(0)
        + df["num_L6MUX21"].fillna(0)
        + df["f7muxes"].fillna(0)
        + df["f8muxes"].fillna(0)
        + df["f9muxes"].fillna(0)
    )

    # Combine DSP columns.
    # Count 2 9X9Ds as 1 DSP (rounding up).
    df["dsps"] = (
        df["dsps"].fillna(0)
        + df["altmult_accum"].fillna(0)
        + df["dsp48e2s"].fillna(0)
        + df["DSP48E2"].fillna(0)
        + df["num_MULT18X18D"].fillna(0)
        + df["MULT18X18D"].fillna(0)
        + (df["num_MULT9X9D"].fillna(0) / 2).apply(np.ceil)
        + df["num_ALU54B"].fillna(0)
    )

    # Aggregate time into one column..
    df["time_s"] = df[
        ["time_s", "yosys_runtime_s", "synth_time", "diamond_cpu_time"]
    ].aggregate(axis="columns", func=_assert_one)

    # Drop unused columns.
    df.drop(
        columns=[
            "yosys_runtime_s",
            "synth_time",
            "diamond_cpu_time",
            "altmult_accum",
            "opt_time",
            "dsp48e2s",
            "DSP48E2",
            "num_MULT18X18D",
            "MULT18X18D",
            "num_MULT9X9D",
            "num_ALU54B",
            "BUFG",
            "FDRE",
            "IBUF",
            "OBUF",
            "TRELLIS_FF",
            "clb_regs",
            "carry8s",
            "clb_luts",
            "f7muxes",
            "f8muxes",
            "f9muxes",
            "user_constraints_met",
            "worst_negative_slack",
            "clock_name",
            "clock_period_ns",
            "clock_frequency_MHz",
            "num_LUT4",
            "num_CCU2C",
            "num_PFUMX",
            "CARRY4",
            "FDCE",
            "LUT2",
            "num_L6MUX21",
        ],
        inplace=True,
    )

    def _all_equal(series: pandas.Series):
        """Check that all elements are equal, and return that element."""
        assert type(series) == pandas.Series
        assert series.unique().size == 1
        assert (series == series.unique()[0]).all()
        return series.unique()[0]

    # Combine all iterations for the same (arch, tool, benchmark).
    df = (
        df.groupby(["architecture", "tool", "identifier"])
        .agg(
            {
                "time_s": np.median,
                "luts": _all_equal,
                "dsps": _all_equal,
                "carries": _all_equal,
                "muxes": _all_equal,
            }
        )
        .reset_index()
    )

    df.to_csv(out_filepath, index=False)


def task_dsp_benchmarks():
    """Run DSP benchmarks.

    This function defines the task for running the DSP benchmarks."""

    manifest = utils.get_manifest()
    iterations = manifest["iterations"]
    dsp_benchmarks = manifest["dsp_benchmarks"]

    # Base filepath for all DSP benchmark run outputs.
    base_filepath = utils.output_dir() / "dsp_benchmarks"

    # Filepaths of final output data, in JSON format.
    collected_data_output_filepaths = []

    for iter, benchmark in itertools.product(range(iterations), dsp_benchmarks):
        filepath = Path(benchmark["filepath"])

        assert len(benchmark["outputs"]) == 1, "Can't handle multiple outputs yet"

        lakeroad_xilinx_ultrascale_plus_base_filepath = (
            base_filepath
            / "lakeroad_xilinx_ultrascale_plus"
            / f"iter{iter}"
            / filepath.stem
        )
        yield make_lakeroad_task(
            iteration=iter,
            identifier=filepath.stem,
            collected_data_output_filepath=(
                base_filepath
                / "all_results"
                / f"lakeroad_xilinx_ultrascale_plus_{filepath.stem}_iter{iter}.json"
            ),
            template="dsp",
            out_module_name="out",
            out_filepath=lakeroad_xilinx_ultrascale_plus_base_filepath / filepath.name,
            architecture="xilinx-ultrascale-plus",
            time_filepath=lakeroad_xilinx_ultrascale_plus_base_filepath
            / filepath.with_suffix(".time").name,
            json_filepath=lakeroad_xilinx_ultrascale_plus_base_filepath
            / filepath.with_suffix(".json").name,
            verilog_module_filepath=benchmark["filepath"],
            top_module_name=benchmark["module_name"],
            verilog_module_out_signal=(
                benchmark["outputs"][0][0],
                benchmark["outputs"][0][1],
            ),
            name=f"{filepath.stem}_lakeroad_xilinx_ultrascale_plus_iter{iter}",
            initiation_interval=benchmark["initiation_interval"],
            inputs=[(name, int(bw)) for [name, bw] in benchmark["inputs"]],
            clock_name=benchmark["clock_name"],
            reset_name=benchmark["reset_name"] if "reset_name" in benchmark else None,
            timeout=(
                benchmark["timeout"]["xilinx_ultrascale_plus"]
                if (
                    "timeout" in benchmark
                    and "xilinx_ultrascale_plus" in benchmark["timeout"]
                )
                else None
            ),
            expect_fail=(
                True
                if (
                    "expect_fail" in benchmark
                    and "xilinx_ultrascale_plus" in benchmark["expect_fail"]
                )
                else False
            ),
        )
        if not (
            True
            if (
                "expect_fail" in benchmark
                and "xilinx_ultrascale_plus" in benchmark["expect_fail"]
            )
            else False
        ):
            collected_data_output_filepaths.append(
                base_filepath
                / "all_results"
                / f"lakeroad_xilinx_ultrascale_plus_{filepath.stem}_iter{iter}.json"
            )
            yield verilator.make_verilator_task(
                name=f"simulate_{filepath.stem}_lakeroad_xilinx_ultrascale_plus_iter{iter}",
                obj_dir_dir=(
                    lakeroad_xilinx_ultrascale_plus_base_filepath / "verilator_obj_dirs"
                ),
                test_module_filepath=(
                    lakeroad_xilinx_ultrascale_plus_base_filepath / filepath.name
                ),
                ground_truth_module_filepath=benchmark["filepath"],
                include_dirs=benchmark["verilator_include_dirs"][
                    "xilinx_ultrascale_plus"
                ],
                extra_args=benchmark["extra_verilator_args"]["xilinx_ultrascale_plus"],
                module_inputs=[(name, int(bw)) for [name, bw] in benchmark["inputs"]],
                testbench_cc_filepath=lakeroad_xilinx_ultrascale_plus_base_filepath
                / "testbench.cc",
                testbench_exe_filepath=lakeroad_xilinx_ultrascale_plus_base_filepath
                / "testbench",
                testbench_inputs_filepath=lakeroad_xilinx_ultrascale_plus_base_filepath
                / "testbench_inputs.txt",
                testbench_stdout_log_filepath=(
                    lakeroad_xilinx_ultrascale_plus_base_filepath / "testbench.stdout"
                ),
                testbench_stderr_log_filepath=(
                    lakeroad_xilinx_ultrascale_plus_base_filepath / "testbench.stderr"
                ),
                makefile_filepath=(
                    lakeroad_xilinx_ultrascale_plus_base_filepath / "Makefile"
                ),
                clock_name=benchmark["clock_name"],
                initiation_interval=benchmark["initiation_interval"],
                output_signal=benchmark["outputs"][0][0],
            )

        lakeroad_lattice_ecp5_base_filepath = (
            base_filepath / "lakeroad_lattice_ecp5" / f"iter{iter}" / filepath.stem
        )
        yield make_lakeroad_task(
            iteration=iter,
            identifier=filepath.stem,
            collected_data_output_filepath=(
                base_filepath
                / "all_results"
                / f"lakeroad_lattice_ecp5_{filepath.stem}_iter{iter}.json"
            ),
            template="dsp",
            out_module_name="out",
            out_filepath=lakeroad_lattice_ecp5_base_filepath / filepath.name,
            architecture="lattice-ecp5",
            time_filepath=lakeroad_lattice_ecp5_base_filepath
            / filepath.with_suffix(".time").name,
            json_filepath=lakeroad_lattice_ecp5_base_filepath
            / filepath.with_suffix(".json").name,
            verilog_module_filepath=benchmark["filepath"],
            top_module_name=benchmark["module_name"],
            verilog_module_out_signal=(
                benchmark["outputs"][0][0],
                benchmark["outputs"][0][1],
            ),
            name=f"{filepath.stem}_lakeroad_lattice_ecp5_iter{iter}",
            initiation_interval=benchmark["initiation_interval"],
            inputs=[(name, int(bw)) for [name, bw] in benchmark["inputs"]],
            clock_name=benchmark["clock_name"],
            reset_name=benchmark["reset_name"] if "reset_name" in benchmark else None,
            timeout=(
                benchmark["timeout"]["lattice_ecp5"]
                if ("timeout" in benchmark and "lattice_ecp5" in benchmark["timeout"])
                else None
            ),
            expect_fail=(
                True
                if (
                    "expect_fail" in benchmark
                    and "lattice_ecp5" in benchmark["expect_fail"]
                )
                else False
            ),
        )
        if not (
            True
            if (
                "expect_fail" in benchmark
                and "lattice_ecp5" in benchmark["expect_fail"]
            )
            else False
        ):
            collected_data_output_filepaths.append(
                base_filepath
                / "all_results"
                / f"lakeroad_lattice_ecp5_{filepath.stem}_iter{iter}.json"
            )
            yield verilator.make_verilator_task(
                name=f"simulate_{filepath.stem}_lakeroad_lattice_ecp5_iter{iter}",
                obj_dir_dir=(
                    lakeroad_lattice_ecp5_base_filepath / "verilator_obj_dirs"
                ),
                test_module_filepath=(
                    lakeroad_lattice_ecp5_base_filepath / filepath.name
                ),
                ground_truth_module_filepath=benchmark["filepath"],
                include_dirs=benchmark["verilator_include_dirs"]["lattice_ecp5"],
                extra_args=benchmark["extra_verilator_args"]["lattice_ecp5"],
                module_inputs=[(name, int(bw)) for [name, bw] in benchmark["inputs"]],
                testbench_cc_filepath=lakeroad_lattice_ecp5_base_filepath
                / "testbench.cc",
                testbench_exe_filepath=lakeroad_lattice_ecp5_base_filepath
                / "testbench",
                testbench_inputs_filepath=lakeroad_lattice_ecp5_base_filepath
                / "testbench_inputs.txt",
                testbench_stdout_log_filepath=(
                    lakeroad_lattice_ecp5_base_filepath / "testbench.stdout"
                ),
                testbench_stderr_log_filepath=(
                    lakeroad_lattice_ecp5_base_filepath / "testbench.stderr"
                ),
                makefile_filepath=(lakeroad_lattice_ecp5_base_filepath / "Makefile"),
                clock_name=benchmark["clock_name"],
                initiation_interval=benchmark["initiation_interval"],
                output_signal=benchmark["outputs"][0][0],
            )

        # Intel
        lakeroad_intel_base_filepath = (
            base_filepath / "lakeroad_intel" / f"iter{iter}" / filepath.stem
        )
        yield make_lakeroad_task(
            iteration=iter,
            identifier=filepath.stem,
            collected_data_output_filepath=(
                base_filepath
                / "all_results"
                / f"lakeroad_intel_{filepath.stem}_iter{iter}.json"
            ),
            template="dsp",
            out_module_name="out",
            out_filepath=lakeroad_intel_base_filepath / filepath.name,
            architecture="intel",
            time_filepath=(
                lakeroad_intel_base_filepath / filepath.with_suffix(".time").name
            ),
            json_filepath=(
                lakeroad_intel_base_filepath / filepath.with_suffix(".json").name
            ),
            verilog_module_filepath=benchmark["filepath"],
            top_module_name=benchmark["module_name"],
            verilog_module_out_signal=(
                benchmark["outputs"][0][0],
                benchmark["outputs"][0][1],
            ),
            name=f"{filepath.stem}_lakeroad_intel_iter{iter}",
            initiation_interval=benchmark["initiation_interval"],
            inputs=[(name, int(bw)) for [name, bw] in benchmark["inputs"]],
            clock_name=benchmark["clock_name"],
            reset_name=benchmark["reset_name"] if "reset_name" in benchmark else None,
            timeout=(
                benchmark["timeout"]["intel"]
                if ("timeout" in benchmark and "intel" in benchmark["timeout"])
                else None
            ),
            expect_fail=(
                True
                if ("expect_fail" in benchmark and "intel" in benchmark["expect_fail"])
                else False
            ),
        )
        if not (
            True
            if ("expect_fail" in benchmark and "intel" in benchmark["expect_fail"])
            else False
        ):
            # Only collect data if we don't expect failure.
            collected_data_output_filepaths.append(
                base_filepath
                / "all_results"
                / f"lakeroad_intel_{filepath.stem}_iter{iter}.json"
            )
            # Only run Verilator if we don't expect failure on this architecture.
            yield verilator.make_verilator_task(
                name=f"simulate_{filepath.stem}_lakeroad_intel_iter{iter}",
                obj_dir_dir=(lakeroad_intel_base_filepath / "verilator_obj_dirs"),
                test_module_filepath=(lakeroad_intel_base_filepath / filepath.name),
                ground_truth_module_filepath=benchmark["filepath"],
                include_dirs=benchmark["verilator_include_dirs"]["intel"],
                extra_args=benchmark["extra_verilator_args"]["intel"],
                module_inputs=[(name, int(bw)) for [name, bw] in benchmark["inputs"]],
                testbench_cc_filepath=lakeroad_intel_base_filepath / "testbench.cc",
                testbench_exe_filepath=lakeroad_intel_base_filepath / "testbench",
                testbench_inputs_filepath=(
                    lakeroad_intel_base_filepath / "testbench_inputs.txt"
                ),
                testbench_stdout_log_filepath=(
                    lakeroad_intel_base_filepath / "testbench.stdout"
                ),
                testbench_stderr_log_filepath=(
                    lakeroad_intel_base_filepath / "testbench.stderr"
                ),
                makefile_filepath=lakeroad_intel_base_filepath / "Makefile",
                clock_name=benchmark["clock_name"],
                initiation_interval=benchmark["initiation_interval"],
                output_signal=benchmark["outputs"][0][0],
            )

        yield hardware_compilation.make_xilinx_ultrascale_plus_yosys_synthesis_task(
            collect_args={
                "collected_data_filepath": (
                    base_filepath
                    / "all_results"
                    / f"yosys_xilinx_ultrascale_plus_{filepath.stem}_iter{iter}.json"
                ),
                "iteration": iter,
                "identifier": filepath.stem,
            },
            input_filepath=filepath,
            output_dirpath=base_filepath
            / "yosys_xilinx_ultrascale_plus"
            / f"iter{iter}"
            / filepath.stem,
            module_name=benchmark["module_name"],
            name=f"{filepath.stem}_yosys_xilinx_ultrascale_plus_iter{iter}",
        )
        collected_data_output_filepaths.append(
            base_filepath
            / "all_results"
            / f"yosys_xilinx_ultrascale_plus_{filepath.stem}_iter{iter}.json"
        )

        yield hardware_compilation.make_lattice_ecp5_yosys_synthesis_task(
            collect_args={
                "collected_data_filepath": (
                    base_filepath
                    / "all_results"
                    / f"yosys_lattice_ecp5_{filepath.stem}_iter{iter}.json"
                ),
                "iteration": iter,
                "identifier": filepath.stem,
            },
            input_filepath=filepath,
            output_dirpath=base_filepath
            / "yosys_lattice_ecp5"
            / f"iter{iter}"
            / filepath.stem,
            module_name=benchmark["module_name"],
            name=f"{filepath.stem}_yosys_lattice_ecp5_iter{iter}",
        )
        collected_data_output_filepaths.append(
            base_filepath
            / "all_results"
            / f"yosys_lattice_ecp5_{filepath.stem}_iter{iter}.json"
        )

        yield hardware_compilation.make_xilinx_ultrascale_plus_vivado_synthesis_task_opt(
            collect_args={
                "collected_data_filepath": (
                    base_filepath
                    / "all_results"
                    / f"vivado_{filepath.stem}_iter{iter}.json"
                ),
                "iteration": iter,
                "identifier": filepath.stem,
            },
            input_filepath=filepath,
            output_dirpath=base_filepath / "vivado" / f"iter{iter}" / filepath.stem,
            module_name=benchmark["module_name"],
            name=f"{filepath.stem}_vivado_iter{iter}",
        )
        collected_data_output_filepaths.append(
            base_filepath / "all_results" / f"vivado_{filepath.stem}_iter{iter}.json"
        )

        yield hardware_compilation.make_lattice_ecp5_diamond_synthesis_task(
            collect_args={
                "collected_data_filepath": (
                    base_filepath
                    / "all_results"
                    / f"diamond_{filepath.stem}_iter{iter}.json"
                ),
                "iteration": iter,
                "identifier": filepath.stem,
            },
            input_filepath=filepath,
            output_dirpath=base_filepath / "diamond" / f"iter{iter}" / filepath.stem,
            module_name=benchmark["module_name"],
            name=f"{filepath.stem}_diamond_iter{iter}",
        )
        collected_data_output_filepaths.append(
            base_filepath / "all_results" / f"diamond_{filepath.stem}_iter{iter}.json"
        )

        if manifest["use_quartus"]:
            yield quartus.make_quartus_task(
                task_name=f"{filepath.stem}_quartus_iter{iter}",
                identifier=f"{filepath.stem}",
                collected_data_output_filepath=(
                    base_filepath
                    / "all_results"
                    / f"quartus_{filepath.stem}_iter{iter}.json"
                ),
                iteration=iter,
                top_module_name=benchmark["module_name"],
                # Note that we need to use the absolute path here.
                source_input_filepath=(utils.lakeroad_evaluation_dir() / filepath),
                summary_output_filepath=(
                    base_filepath
                    / "quartus"
                    / f"iter{iter}"
                    / filepath.stem
                    / "quartus_map_summary.txt"
                ),
                json_output_filepath=(
                    base_filepath
                    / "quartus"
                    / f"iter{iter}"
                    / filepath.stem
                    / "quartus_map_summary.json"
                ),
                time_output_filepath=(
                    base_filepath
                    / "quartus"
                    / f"iter{iter}"
                    / filepath.stem
                    / "quartus.time"
                ),
            )
            collected_data_output_filepaths.append(
                base_filepath
                / "all_results"
                / f"quartus_{filepath.stem}_iter{iter}.json"
            )

    # Data collection task.
    csv_output = base_filepath / "all_results" / "all_results_collected.csv"
    yield {
        "name": "collect_data",
        "file_dep": collected_data_output_filepaths,
        "targets": [csv_output],
        "actions": [
            (
                _collect_dsp_benchmark_data,
                [],
                {
                    "filepaths": collected_data_output_filepaths,
                    "output_filepath": csv_output,
                },
            )
        ],
    }

    # Data cleaning task.
    cleaned_csv_output = utils.output_dir() / "collected_data" / "dsp_benchmarks.csv"
    yield {
        "name": "clean_data",
        "file_dep": [csv_output],
        "targets": [cleaned_csv_output],
        "actions": [
            (
                _clean_dsp_benchmark_data,
                [],
                {
                    "in_filepath": csv_output,
                    "out_filepath": cleaned_csv_output,
                },
            )
        ],
    }
