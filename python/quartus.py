import utils
from dataclasses import dataclass
import dataclasses
import json
from pathlib import Path
import re
import subprocess
import tempfile
from typing import Dict, List, Optional, Union, Any, Tuple
import time
import hardware_compilation
import logging


def run_quartus(
    top_module_name: str,
    source_input_filepath: Union[str, Path],
    summary_output_filepath: Union[str, Path],
    json_output_filepath: Union[str, Path],
    time_output_filepath: Union[str, Path],
):
    """Run Quartus on a design, generate a summary report.

    Args:
        top_module_name (str): Name of top module.
        source_input_filepath (Union[str, Path]): Verilog source file.
        summary_output_filepath (Union[str, Path]): Quartus summary file.
        json_output_filepath (Union[str, Path]): Summary file, parsed into JSON.
        time_output_filepath (Union[str, Path]): Time file.
    """
    summary_output_filepath = Path(summary_output_filepath)
    json_output_filepath = Path(json_output_filepath)
    time_output_filepath = Path(time_output_filepath)

    # Assumes that Quartus is on the PATH. Could make this an argument if we
    # want to be able to configure the location of Quartus.
    quartus_bin = "quartus_map"

    with tempfile.TemporaryDirectory() as temp_dir_str:
        temp_dir = Path(temp_dir_str)
        start = time.time()
        subprocess.run(
            args=[
                quartus_bin,
                top_module_name,
                "--source",
                source_input_filepath,
            ],
            cwd=temp_dir,
            # Error if Quartus fails and capture the output (and thus don't
            # print to stdout/stderr). These can be handled more gracefully
            # (i.e. catching the exception, printing stderr) if needed.
            check=True,
            capture_output=True,
        )
        end = time.time()

        # Copy summary file over.
        summary_output_filepath.parent.mkdir(parents=True, exist_ok=True)
        summary_output_filepath.write_bytes(
            (temp_dir / f"{top_module_name}.map.summary").read_bytes()
        )

    # Write time file.
    time_output_filepath.parent.mkdir(parents=True, exist_ok=True)
    with open(time_output_filepath, "w") as f:
        print(f"{end-start}s", file=f)

    # Write out JSON file with results.
    json_output_filepath.parent.mkdir(parents=True, exist_ok=True)
    with open(json_output_filepath, "w") as f:
        json.dump(
            dataclasses.asdict(
                parse_quartus_map_summary(summary_output_filepath.read_text())
            ),
            f,
        )


def collect_quartus(
    identifier: str,
    iteration: int,
    time_input_filepath: Union[str, Path],
    json_input_filepath: Union[str, Path],
    collected_data_output_filepath: Union[str, Path],
):
    """_summary_

    Args:
        identifier (str): Identifier for the module being compiled.
        iteration (int): _description_
        time_input_filepath (Union[str, Path]): _description_
        json_input_filepath (Union[str, Path]): _description_
        collected_data_output_filepath (Union[str, Path]): _description_
    """
    with open(json_input_filepath, "r") as f:
        data = json.load(f)
    with open(time_input_filepath, "r") as f:
        time = float(f.read().removesuffix("s\n"))

    assert "time_s" not in data
    data["time_s"] = time

    assert "iteration" not in data
    data["iteration"] = iteration

    assert "tool" not in data
    data["tool"] = "quartus"

    assert "architecture" not in data
    data["architecture"] = "intel"

    assert "identifier" not in data
    data["identifier"] = identifier

    Path(collected_data_output_filepath).parent.mkdir(parents=True, exist_ok=True)
    with open(collected_data_output_filepath, "w") as f:
        json.dump(data, f)


def make_quartus_task(
    identifier: str,
    top_module_name: str,
    source_input_filepath: Union[str, Path],
    summary_output_filepath: Union[str, Path],
    json_output_filepath: Union[str, Path],
    time_output_filepath: Union[str, Path],
    collected_data_output_filepath: Union[str, Path],
    iteration: int,
    task_name: Optional[str] = None,
) -> List:
    """Generate tasks for Quartus.

    See documentation for `run_quartus` and `collect_quartus` for more details."""

    task = {}

    if task_name is not None:
        task["name"] = task_name

    task["actions"] = [
        (
            run_quartus,
            [],
            {
                "top_module_name": top_module_name,
                "source_input_filepath": source_input_filepath,
                "summary_output_filepath": summary_output_filepath,
                "json_output_filepath": json_output_filepath,
                "time_output_filepath": time_output_filepath,
            },
        ),
        (
            collect_quartus,
            [],
            {
                "iteration": iteration,
                "json_input_filepath": json_output_filepath,
                "time_input_filepath": time_output_filepath,
                "collected_data_output_filepath": collected_data_output_filepath,
                "identifier": identifier,
            },
        ),
    ]

    task["targets"] = [
        summary_output_filepath,
        json_output_filepath,
        time_output_filepath,
        collected_data_output_filepath,
    ]

    task["file_dep"] = [source_input_filepath]

    return task


@dataclass
class QuartusMapSummary:
    dsps: int


def parse_quartus_map_summary(summary_txt: str) -> QuartusMapSummary:
    matches = list(
        re.finditer(r"^Total DSP Blocks : (\d+)$", summary_txt, flags=re.MULTILINE)
    )
    assert len(matches) == 1
    assert len(matches[0].groups()) == 1
    dsps = int(matches[0].group(1))

    return QuartusMapSummary(dsps=dsps)


def make_intel_yosys_synthesis_task(
    input_filepath: Union[str, Path],
    output_dirpath: Union[str, Path],
    module_name: str,
    clock_info: Optional[Tuple[str, float]] = None,
    name: Optional[str] = None,
    collect_args: Optional[Dict[str, Any]] = None,
):
    """Wrapper over Yosys synthesis function which creates a DoIt Task."""
    if clock_info is not None:
        logging.warn("clock_info not supported for Yosys.")
    output_dirpath = Path(output_dirpath)
    json_filepath = output_dirpath / f"{module_name}.json"
    output_filepath = output_dirpath / f"{module_name}.sv"
    time_filepath = output_dirpath / f"{module_name}.time"
    log_filepath = output_dirpath / f"{module_name}.log"
    resources_filepath = output_dirpath / f"{module_name}_resource_utilization.json"

    task = {
        "actions": [
            (
                hardware_compilation.yosys_synthesis,
                [],
                {
                    "json_filepath": json_filepath,
                    "input_filepath": input_filepath,
                    "module_name": module_name,
                    "output_filepath": output_filepath,
                    "time_filepath": time_filepath,
                    "synth_command": "synth_intel",
                    "log_filepath": log_filepath,
                    "resources_filepath": resources_filepath,
                },
            )
        ],
        "file_dep": [input_filepath],
        "targets": [
            json_filepath,
            output_filepath,
            time_filepath,
            log_filepath,
            resources_filepath,
        ],
    }

    if name is not None:
        task["name"] = name

    if collect_args is not None:
        task["actions"].append(
            (
                hardware_compilation.collect,
                [],
                {
                    "iteration": collect_args["iteration"],
                    "identifier": collect_args["identifier"],
                    "json_filepath": json_filepath,
                    "collected_data_filepath": collect_args["collected_data_filepath"],
                    "architecture": "lattice_ecp5",
                    "tool": "yosys",
                },
            )
        )
        task["targets"].append(collect_args["collected_data_filepath"])

    return task
