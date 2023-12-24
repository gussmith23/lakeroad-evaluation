"""File defining hardware compilation tasks using the DoIt framework."""

from pathlib import Path

import pandas as pd
from hardware_compilation import *
import doit
import utils


@doit.task_params(
    [
        {
            "name": "baseline_instructions_dir",
            "default": str(utils.lakeroad_evaluation_dir() / "instructions" / "src"),
            "type": str,
        },
    ]
)
def task_baseline_synthesis(baseline_instructions_dir: str):
    """DoIt task creator for creating baseline synthesis tasks for instructions."""

    output_dir_base = utils.output_dir() / "baseline"

    json_filepaths = []

    for instruction_file in Path(baseline_instructions_dir).glob("*"):
        (
            vivado_baseline_synthesis_task,
            (json_file, _, _, _),
        ) = make_xilinx_ultrascale_plus_vivado_synthesis_task_opt(
            input_filepath=instruction_file,
            output_dirpath=output_dir_base / "vivado" / instruction_file.stem,
            module_name=instruction_file.stem,
            extra_summary_fields={
                "tool": "vivado",
                "identifier": instruction_file.stem,
                "architecture": "xilinx-ultrascale-plus",
            },
            name=f"vivado_{instruction_file.stem}",
        )
        yield vivado_baseline_synthesis_task
        json_filepaths.append(json_file)

        (task, (json_filepath, _, _)) = make_lattice_ecp5_yosys_synthesis_task(
            input_filepath=instruction_file,
            output_dirpath=output_dir_base
            / "yosys_lattice_ecp5"
            / instruction_file.stem,
            module_name=instruction_file.stem,
            name=f"yosys_lattice_ecp5_{instruction_file.stem}",
            extra_summary_fields={
                "tool": "yosys",
                "identifier": instruction_file.stem,
                "architecture": "lattice-ecp5",
            },
        )
        yield task
        json_filepaths.append(json_filepath)

        (
            yosys_xilinx_ultrascale_plus_baseline_synthesis_task,
            (json_filepath, _, _),
        ) = make_xilinx_ultrascale_plus_yosys_synthesis_task(
            input_filepath=instruction_file,
            output_dirpath=output_dir_base
            / "yosys_xilinx_ultrascale_plus"
            / instruction_file.stem,
            module_name=instruction_file.stem,
            extra_summary_fields={
                "tool": "yosys",
                "identifier": instruction_file.stem,
                "architecture": "xilinx-ultrascale-plus",
            },
            name=f"yosys_xilinx_ultrascale_plus_{instruction_file.stem}",
        )
        yield yosys_xilinx_ultrascale_plus_baseline_synthesis_task
        json_filepaths.append(json_filepath)

        (task, (json_filepath, _)) = make_lattice_ecp5_diamond_synthesis_task(
            input_filepath=instruction_file,
            output_dirpath=output_dir_base / "diamond" / instruction_file.stem,
            module_name=instruction_file.stem,
            name=f"diamond_{instruction_file.stem}",
            extra_summary_fields={
                "tool": "diamond",
                "identifier": instruction_file.stem,
                "architecture": "lattice-ecp5",
            },
        )
        yield task
        json_filepaths.append(json_filepath)

    def _impl(output_filepath, json_filepaths):
        Path(output_filepath).parent.mkdir(parents=True, exist_ok=True)
        df = pd.DataFrame.from_records(
            json.load(open(filename)) for filename in json_filepaths
        )
        df.to_csv(output_filepath)

    output_filepath = output_dir_base / "baseline_summary.csv"
    yield {
        "name": "collect_baseline_summary",
        "actions": [
            (
                _impl,
                [],
                {"json_filepaths": json_filepaths, "output_filepath": output_filepath},
            )
        ],
        "file_dep": json_filepaths,
        "targets": [output_filepath],
    }
