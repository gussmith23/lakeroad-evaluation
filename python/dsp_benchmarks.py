from pathlib import Path
from typing import Optional, Union
from lakeroad import invoke_lakeroad
import utils
import itertools


def make_dsp_benchmark_task(
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
                "template": template,
                "out_filepath": out_filepath,
                "module_name": out_module_name,
                "architecture": architecture,
                "time_filepath": time_filepath,
                "json_filepath": json_filepath,
                "verilg_module_filepath": verilog_module_filepath,
                "top_module_name": top_module_name,
                "verilog_module_out_signal": verilog_module_out_signal,
            },
        )
    ]


def task_dsp_benchmarks():
    """Generate tasks for DSP benchmark experiments."""

    manifest = utils.get_manifest()
    iterations = manifest["iterations"]
    dsp_benchmark_filepaths = manifest["dsp_benchmark_filepaths"]

    for iter, benchmark_filepath in itertools.product(
        range(iterations), dsp_benchmark_filepaths
    ):
        pass

    return {}
