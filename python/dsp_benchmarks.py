from pathlib import Path
from typing import Optional, Union
from lakeroad import invoke_lakeroad
import utils
import itertools


def _make_dsp_benchmark_task(
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

    for iter, benchmark in itertools.product(range(iterations), dsp_benchmarks):
        filepath = Path(benchmark["filepath"])
        yield _make_dsp_benchmark_task(
            template=benchmark["template"],
            out_module_name="out",
            out_filepath=utils.output_dir() / f"iter{iter}" / filepath.name,
            architecture=benchmark["architecture"],
            time_filepath=utils.output_dir()
            / f"iter{iter}"
            / filepath.with_suffix(".time").name,
            json_filepath=utils.output_dir()
            / f"iter{iter}"
            / filepath.with_suffix(".json").name,
            verilog_module_filepath=benchmark["filepath"],
            top_module_name=benchmark["module_name"],
            verilog_module_out_signal=benchmark["output_signal"],
            name=Path(benchmark["filepath"]).stem + f"_iter{iter}",
        )
