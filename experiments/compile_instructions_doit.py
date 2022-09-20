"""File defining hardware compilation tasks using the DoIt framework."""

from pathlib import Path
from typing import Dict
from hardware_compilation import *
import doit
import yaml
import utils


@doit.task_params(
    [
        {
            "name": "instructions_file",
            "default": str(utils.lakeroad_evaluation_dir() / "instructions.yaml"),
            "type": str,
        },
    ]
)
def task_compile_instrs(instructions_file: str):
    """DoIt task creator for compiling instructions with various backends.

    TODO We may want to support compiling instructions for the same architecture
    using different backends, e.g. compiling Lattice with Yosys and Diamond, or
    Xilinx with Vivado and Yosys."""

    def _make_task(
        instruction: Dict,
    ):
        """Make task from an instruction configuration.

        We may want to split this into "make_vivado_task" and "make_yosys_task"
        etc."""
        module_name = instruction["verilog_module_name"]
        # TODO(@gussmith23): Right now, Lakeroad spits the module out with _1
        # appended to the end of the filename. I understand why we did it (to
        # support multiple outputs) but we should clean up that API.
        verilog_filepath = utils.output_dir() / (str(instruction["relative_verilog_filepath"]) + "_1")

        actions, file_dep, targets = [], [], []

        if "vivado" in instruction:
            synth_opt_place_route_output_filepath = (
                utils.output_dir()
                / instruction["vivado"]["synth_opt_place_route_relative_filepath"]
            )
            log_filepath = utils.output_dir() / instruction["vivado"]["log_filepath"]
            actions = [
                (
                    xilinx_ultrascale_plus_vivado_synthesis,
                    [
                        verilog_filepath,
                        synth_opt_place_route_output_filepath,
                        module_name,
                        log_filepath,
                    ],
                )
            ]
            targets = [synth_opt_place_route_output_filepath, log_filepath]
            file_dep = [verilog_filepath]
        # TODO(@gussmith23) This is wrong; we should be switching based off architecture, I think.
        elif "yosys" in instruction:
            synth_out_sv = (
                utils.output_dir() / instruction["yosys"]["synth_sv_relative_filepath"]
            )
            synth_out_json = (
                utils.output_dir() / instruction["yosys"]["synth_json_relative_filepath"]
            )
            yosys_log_path = (
                utils.output_dir() / instruction["yosys"]["yosys_log_filepath"]
            )
            nextpnr_log_path = (
                utils.output_dir() / instruction["yosys"]["nextpnr_log_filepath"]
            )

            actions = [
                (
                    lattice_ecp5_yosys_nextpnr_synthesis,
                    [
                        verilog_filepath,
                        module_name,
                        synth_out_sv,
                        synth_out_json,
                        yosys_log_path,
                        nextpnr_log_path,
                    ],
                )
            ]
            targets = [synth_out_sv, synth_out_json, yosys_log_path, nextpnr_log_path]
            file_dep = [verilog_filepath]

        return {
            "actions": actions,
            "file_dep": file_dep,
            "targets": targets,
            "name": f"compile_{module_name}",
        }

    with open(instructions_file) as f:
        instructions = yaml.safe_load(f)

    for instruction in instructions:
        yield _make_task(instruction)
