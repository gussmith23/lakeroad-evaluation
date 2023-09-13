import enum
import shutil
from dataclasses import dataclass
import json
from pathlib import Path
import subprocess
import tempfile
from typing import Dict, List, Optional, Self, Union, Any
import time
import hardware_compilation


class IntelFamily(enum.StrEnum):
    def from_str(v) -> Self:
        match v:
            case "cyclonev" | IntelFamily.CYCLONEV:
                return IntelFamily.CYCLONEV
            case "cycloneiv" | IntelFamily.CYCLONEIV:
                return IntelFamily.CYCLONEIV
            case _:
                raise ValueError(f"Unknown family: {v}")

    CYCLONEV = "Cyclone V"
    CYCLONEIV = "Cyclone IV"


def run_quartus(
    top_module_name: str,
    source_input_filepath: Union[str, Path],
    summary_output_filepath: Union[str, Path],
    json_output_filepath: Union[str, Path],
    time_output_filepath: Union[str, Path],
    verilog_output_filepath: Union[str, Path],
    family: IntelFamily,
    working_directory: Union[str, Path] = Path(tempfile.TemporaryDirectory().name),
    extra_summary_fields: Dict[str, Any] = {},
):
    """Run Quartus on a design, generate a summary report.

    Args:
        top_module_name (str): Name of top module.
        source_input_filepath (Union[str, Path]): Verilog source file.
        summary_output_filepath (Union[str, Path]): Quartus summary file.
        json_output_filepath (Union[str, Path]): Summary file, parsed into JSON.
        time_output_filepath (Union[str, Path]): Time file.
        working_directory (Union[str, Path], optional): Working directory for
          Quartus. Defaults to temp dir. Quartus is weird: it produces
          intermediate files that are needed by multiple commands, so working
          directory ends up being important.
    """
    summary_output_filepath = Path(summary_output_filepath)
    json_output_filepath = Path(json_output_filepath)
    time_output_filepath = Path(time_output_filepath)
    verilog_output_filepath = Path(verilog_output_filepath)

    # Assumes that Quartus is on the PATH. Could make this an argument if we
    # want to be able to configure the location of Quartus.
    quartus_bin = "quartus_map"

    temp_dir = Path(working_directory)
    temp_dir.mkdir(parents=True, exist_ok=True)

    # Filepath where we'll write the "VQM" file. This file is just Verilog from
    # what I can tell.
    vqm_file = tempfile.NamedTemporaryFile(suffix=".vqm", dir=temp_dir)

    # Generate family string.
    match family:
        case IntelFamily.CYCLONEV:
            family_str = "cyclonev"
        case IntelFamily.CYCLONEIV:
            family_str = "cycloneiv"

    start = time.time()
    subprocess.run(
        args=[
            quartus_bin,
            top_module_name,
            "--source",
            source_input_filepath,
            f"--family={family_str}",
        ],
        cwd=temp_dir,
        # Error if Quartus fails and capture the output (and thus don't
        # print to stdout/stderr). These can be handled more gracefully
        # (i.e. catching the exception, printing stderr) if needed.
        check=True,
        capture_output=True,
    )
    subprocess.run(
        args=[
            "quartus_cdb",
            top_module_name,
            f"--vqm={Path(vqm_file.name).stem}",
        ],
        cwd=temp_dir,
        check=True,
        capture_output=True,
    )
    end = time.time()

    # Copy Verilog file over.
    verilog_output_filepath.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(vqm_file.name, verilog_output_filepath)

    # Generate summary JSON.
    summary = hardware_compilation.count_resources_in_verilog_src(
        verilog_src=verilog_output_filepath.read_text(),
        module_name=top_module_name,
    )

    assert "time_s" not in summary
    summary["time_s"] = end - start

    for key in extra_summary_fields:
        assert key not in summary
        summary[key] = extra_summary_fields[key]

    json_output_filepath.parent.mkdir(parents=True, exist_ok=True)
    json.dump(
        summary,
        fp=open(json_output_filepath, "w"),
    )


def make_quartus_task(
    identifier: str,
    top_module_name: str,
    source_input_filepath: Union[str, Path],
    base_output_dirpath: Union[str, Path],
    iteration: int,
    family: IntelFamily,
    task_name: Optional[str] = None,
    working_directory=None,
    extra_summary_fields: Dict[str, Any] = {},
) -> List:
    """Generate tasks for Quartus.

    See documentation for `run_quartus` and `collect_quartus` for more details."""

    task = {}

    base_output_dirpath = Path(base_output_dirpath)

    summary_output_filepath = base_output_dirpath / f"{top_module_name}.map.summary"
    json_output_filepath = base_output_dirpath / f"{top_module_name}.map.json"
    time_output_filepath = base_output_dirpath / f"{top_module_name}.map.time"
    collected_data_output_filepath = (
        base_output_dirpath / f"{top_module_name}.map.collected.json"
    )
    verilog_output_filepath = base_output_dirpath / f"{top_module_name}.v"

    if task_name is not None:
        task["name"] = task_name

    run_quartus_args = {
        "top_module_name": top_module_name,
        "source_input_filepath": source_input_filepath,
        "summary_output_filepath": summary_output_filepath,
        "json_output_filepath": json_output_filepath,
        "time_output_filepath": time_output_filepath,
        "verilog_output_filepath": verilog_output_filepath,
        "extra_summary_fields": extra_summary_fields,
    }

    if working_directory is not None:
        run_quartus_args["working_directory"] = working_directory

    if family is not None:
        run_quartus_args["family"] = family

    task["actions"] = [
        (
            run_quartus,
            [],
            run_quartus_args,
        ),
    ]

    task["targets"] = [
        summary_output_filepath,
        json_output_filepath,
        time_output_filepath,
        collected_data_output_filepath,
        verilog_output_filepath,
    ]

    task["file_dep"] = [source_input_filepath]

    return (task, (json_output_filepath, verilog_output_filepath))
