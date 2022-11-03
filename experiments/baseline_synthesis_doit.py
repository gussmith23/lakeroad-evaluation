"""File defining hardware compilation tasks using the DoIt framework."""

from pathlib import Path
from typing import Union
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

    def _make_baseline_vivado_synthesis_task(
        baseline_instruction_filepath: Union[str, Path]
    ):
        baseline_instruction_filepath = Path(baseline_instruction_filepath)
        module_name = baseline_instruction_filepath.stem
        synth_opt_place_route_output_filepath = (
            output_dir_base / "vivado" / baseline_instruction_filepath.name
        )
        log_filepath = synth_opt_place_route_output_filepath.with_suffix(".log")
        time_filepath = synth_opt_place_route_output_filepath.with_suffix(".time")

        return {
            "name": f"baseline_vivado_compile_{module_name}",
            "actions": [
                (
                    xilinx_ultrascale_plus_vivado_synthesis,
                    [
                        baseline_instruction_filepath,
                        synth_opt_place_route_output_filepath,
                        module_name,
                        time_filepath,
                        log_filepath,
                    ],
                )
            ],
            "file_dep": [baseline_instruction_filepath],
            "targets": [
                synth_opt_place_route_output_filepath,
                log_filepath,
                time_filepath,
            ],
        }

    def _make_baseline_yosys_nextpnr_synthesis_task(
        baseline_instruction_filepath: Union[str, Path]
    ):
        baseline_instruction_filepath = Path(baseline_instruction_filepath)
        module_name = baseline_instruction_filepath.stem
        nextpnr_output_sv_filepath = (
            output_dir_base / "yosys_nextpnr" / baseline_instruction_filepath.name
        )
        synth_out_json = nextpnr_output_sv_filepath.with_suffix(".json")
        yosys_log_path = (
            nextpnr_output_sv_filepath.parent
            / f"{nextpnr_output_sv_filepath.name}_yosys.log"
        )
        nextpnr_log_path = (
            nextpnr_output_sv_filepath.parent
            / f"{nextpnr_output_sv_filepath.name}_nextpnr.log"
        )
        yosys_time_path = (
            nextpnr_output_sv_filepath.parent
            / f"{nextpnr_output_sv_filepath.name}_yosys.time"
        )
        nextpnr_time_path = (
            nextpnr_output_sv_filepath.parent
            / f"{nextpnr_output_sv_filepath.name}_nextpnr.time"
        )

        return {
            "name": f"baseline_yosys_nextpnr_compile_{module_name}",
            "actions": [
                (
                    lattice_ecp5_yosys_nextpnr_synthesis,
                    [
                        baseline_instruction_filepath,
                        module_name,
                        nextpnr_output_sv_filepath,
                        synth_out_json,
                        yosys_time_path,
                        nextpnr_time_path,
                        yosys_log_path,
                        nextpnr_log_path,
                    ],
                )
            ],
            "targets": [
                nextpnr_output_sv_filepath,
                synth_out_json,
                yosys_log_path,
                nextpnr_log_path,
                yosys_time_path,
                nextpnr_time_path,
            ],
            "file_dep": [baseline_instruction_filepath],
        }

    for instruction_file in Path(baseline_instructions_dir).glob("*"):
        yield _make_baseline_vivado_synthesis_task(instruction_file)
        yield _make_baseline_yosys_nextpnr_synthesis_task(instruction_file)
