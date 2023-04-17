import utils
from dataclasses import dataclass
import dataclasses
import json
from pathlib import Path
import re
import subprocess
import tempfile
from typing import Optional, Union
import time


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

    with tempfile.TemporaryDirectory() as temp_dir_str:
        temp_dir = Path(temp_dir_str)
        start = time.time()
        subprocess.run(
            args=[
                utils.quartus_bin_dir() / "quartus_map",
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


def make_quartus_task(name: Optional[str], **kwargs):

    task = {}

    if name is not None:
        task["name"] = name

    task["actions"] = [(run_quartus, [], kwargs)]

    task["targets"] = [
        kwargs["summary_output_filepath"],
        kwargs["json_output_filepath"],
    ]

    task["file_dep"] = [
        kwargs["source_input_filepath"],
    ]

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
