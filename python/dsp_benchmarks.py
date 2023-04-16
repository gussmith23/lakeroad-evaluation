from pathlib import Path
from lakeroad import make_lakeroad_task
import utils
import itertools
import hardware_compilation
import verilator


def task_dsp_benchmarks():
    """Run DSP benchmarks.

    This function defines the task for running the DSP benchmarks."""

    manifest = utils.get_manifest()
    iterations = manifest["iterations"]
    dsp_benchmarks = manifest["dsp_benchmarks"]

    # Base filepath for all DSP benchmark run outputs.
    base_filepath = utils.output_dir() / "dsp_benchmarks"

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
            include_dirs=benchmark["verilator_include_dirs"],
            extra_args=benchmark["extra_verilator_args"],
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
        )

        yield hardware_compilation.make_xilinx_ultrascale_plus_yosys_synthesis_task(
            input_filepath=filepath,
            output_dirpath=base_filepath
            / "yosys_xilinx_ultrascale_plus"
            / f"iter{iter}"
            / filepath.stem,
            module_name=benchmark["module_name"],
            name=f"{filepath.stem}_yosys_xilinx_ultrascale_plus_iter{iter}",
        )

        yield hardware_compilation.make_lattice_ecp5_yosys_synthesis_task(
            input_filepath=filepath,
            output_dirpath=base_filepath
            / "yosys_lattice_ecp5"
            / f"iter{iter}"
            / filepath.stem,
            module_name=benchmark["module_name"],
            name=f"{filepath.stem}_yosys_lattice_ecp5_iter{iter}",
        )

        yield hardware_compilation.make_xilinx_ultrascale_plus_vivado_synthesis_task_opt(
            input_filepath=filepath,
            output_dirpath=base_filepath / "vivado" / f"iter{iter}" / filepath.stem,
            module_name=benchmark["module_name"],
            name=f"{filepath.stem}_vivado_iter{iter}",
        )

        yield hardware_compilation.make_lattice_ecp5_diamond_synthesis_task(
            input_filepath=filepath,
            output_dirpath=base_filepath / "diamond" / f"iter{iter}" / filepath.stem,
            module_name=benchmark["module_name"],
            name=f"{filepath.stem}_diamond_iter{iter}",
        )
