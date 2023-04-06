from pathlib import Path
from typing import Optional, Union
from lakeroad import invoke_lakeroad
import utils
import itertools
import hardware_compilation


def _make_lakeroad_task(
    template: str,
    out_module_name: str,
    out_filepath: Union[str, Path],
    architecture: str,
    time_filepath: Union[str, Path],
    json_filepath: Union[str, Path],
    verilog_module_filepath: Optional[Union[str, Path]] = None,
    top_module_name: Optional[str] = None,
    verilog_module_out_signal: Optional[str] = None,
    name=None,
):
    task = {}
    if name:
        task["name"] = name

    task["actions"] = [
        (
            invoke_lakeroad,
            [],
            {
                "instruction": None,
                "template": template,
                "out_filepath": out_filepath,
                "module_name": out_module_name,
                "architecture": architecture,
                "time_filepath": time_filepath,
                "json_filepath": json_filepath,
                "verilog_module_filepath": verilog_module_filepath,
                "top_module_name": top_module_name,
                "verilog_module_out_signal": verilog_module_out_signal,
            },
        )
    ]

    return task


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

        lakeroad_xilinx_ultrascale_plus_base_filepath = (
            base_filepath
            / "lakeroad_xilinx_ultrascale_plus"
            / f"iter{iter}"
            / filepath.stem
        )
        yield _make_lakeroad_task(
            template="xilinx-ultrascale-plus-dsp48e2",
            out_module_name="out",
            out_filepath=lakeroad_xilinx_ultrascale_plus_base_filepath / filepath.name,
            architecture="xilinx-ultrascale-plus",
            time_filepath=lakeroad_xilinx_ultrascale_plus_base_filepath
            / filepath.with_suffix(".time").name,
            json_filepath=lakeroad_xilinx_ultrascale_plus_base_filepath
            / filepath.with_suffix(".json").name,
            verilog_module_filepath=benchmark["filepath"],
            top_module_name=benchmark["module_name"],
            verilog_module_out_signal=benchmark["output_signal"],
            name=f"{filepath.stem}_lakeroad_xilinx_ultrascale_plus_iter{iter}",
        )

        lakeroad_lattice_ecp5_base_filepath = (
            base_filepath / "lakeroad_lattice_ecp5" / f"iter{iter}" / filepath.stem
        )
        yield _make_lakeroad_task(
            template="lattice-ecp5-dsp",
            out_module_name="out",
            out_filepath=lakeroad_lattice_ecp5_base_filepath / filepath.name,
            architecture="lattice-ecp5",
            time_filepath=lakeroad_lattice_ecp5_base_filepath
            / filepath.with_suffix(".time").name,
            json_filepath=lakeroad_lattice_ecp5_base_filepath
            / filepath.with_suffix(".json").name,
            verilog_module_filepath=benchmark["filepath"],
            top_module_name=benchmark["module_name"],
            verilog_module_out_signal=benchmark["output_signal"],
            name=f"{filepath.stem}_lakeroad_lattice_ecp5_iter{iter}",
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
