#!/usr/bin/env python3
import utils
from pathlib import Path
import logging
import os
import subprocess
from typing import Literal, Optional, Union
from hardware_compilation import (
    lattice_ecp5_yosys_nextpnr_synthesis,
    xilinx_ultrascale_plus_vivado_synthesis,
)


def compile_with_fud(
    fud_path: Union[str, Path],
    futil_filepath: Union[str, Path],
    out_filepath: Union[str, Path],
) -> str:
    """Compile the given futil file.

    Uses the fud binary at the given path; writes to the file at
    out_filepath."""

    out_filepath = Path(out_filepath)
    out_filepath.parent.mkdir(parents=True, exist_ok=True)
    subprocess.run(
        args=[
            fud_path,
            "e",
            "--to",
            "synth-verilog",
            futil_filepath,
            "-o",
            out_filepath,
        ],
        check=True,
    )


def _compile_with_fud_task_generator(
    calyx_path: Union[str, Path],
    fud_filepath: Union[str, Path],
    output_base_dir: Union[str, Path],
):
    calyx_path = Path(calyx_path)
    for futil_filepath in (calyx_path / "tests" / "correctness").glob("**/*.futil"):
        output_filepath = (
            Path(output_base_dir) / "compiled_with_futil" / f"{futil_filepath.stem}.sv"
        )
        yield {
            "name": f"futil_build_{str(futil_filepath)}",
            "file_dep": [futil_filepath],
            "targets": [output_filepath],
            "actions": [
                (compile_with_fud, [fud_filepath, futil_filepath, output_filepath])
            ],
        }


def task_lattice_ecp5_calyx_end_to_end():
    calyx_path = utils.lakeroad_evaluation_dir() / "calyx-lattice-ecp5"
    output_base_dir = utils.output_dir() / "calyx_end_to_end" / "lattice_ecp5"
    fud_filepath = (
        utils.lakeroad_evaluation_dir() / "calyx-lattice-ecp5" / "bin" / "fud"
    )

    for futil_filepath in (calyx_path / "tests" / "correctness").glob("**/*.futil"):
        relative_dir_in_calyx = futil_filepath.parent.relative_to(calyx_path)
        compiled_sv_filepath = (
            output_base_dir
            / "compiled_with_futil"
            / relative_dir_in_calyx
            / f"{futil_filepath.stem}.sv"
        )
        synth_opt_place_route_sv_output_filepath = (
            output_base_dir
            / "synthesis_results"
            / relative_dir_in_calyx
            / f"{futil_filepath.stem}.sv"
        )
        synth_opt_place_route_json_output_filepath = (
            output_base_dir
            / "synthesis_results"
            / relative_dir_in_calyx
            / f"{futil_filepath.stem}.json"
        )
        yosys_log_filepath = (
            output_base_dir
            / "synthesis_results"
            / relative_dir_in_calyx
            / f"{futil_filepath.stem}_yosys.log"
        )
        nextpnr_log_filepath = (
            output_base_dir
            / "synthesis_results"
            / relative_dir_in_calyx
            / f"{futil_filepath.stem}_nextpnr.log"
        )

    # Filepath with / replaced with _
    file_identifier = str(futil_filepath.relative_to(calyx_path)).replace("/", "_")

    # Task to build the file with fud. (.futil -> .sv)
    yield {
        "name": f"futil_build_{file_identifier}",
        "file_dep": [futil_filepath],
        "targets": [compiled_sv_filepath],
        "actions": [
            (compile_with_fud, [fud_filepath, futil_filepath, compiled_sv_filepath])
        ],
    }

    # Task to synthesize the file with Yosys. (.sv -> .sv, synthesized)
    yield {
        "name": f"synthesize_{file_identifier}",
        "actions": [
            (
                lattice_ecp5_yosys_nextpnr_synthesis,
                [
                    compiled_sv_filepath,
                    "top",
                    synth_opt_place_route_sv_output_filepath,
                    synth_opt_place_route_json_output_filepath,
                    yosys_log_filepath,
                    nextpnr_log_filepath,
                ],
            )
        ],
        "targets": [
            synth_opt_place_route_sv_output_filepath,
            synth_opt_place_route_json_output_filepath,
            yosys_log_filepath,
            nextpnr_log_filepath,
        ],
        "file_dep": [compiled_sv_filepath],
    }


def task_xilinx_ultrascale_plus_calyx_end_to_end():
    calyx_path = utils.lakeroad_evaluation_dir() / "calyx-xilinx-ultrascale-plus"
    output_base_dir = utils.output_dir() / "calyx_end_to_end" / "xilinx_ultrascale_plus"
    fud_filepath = (
        utils.lakeroad_evaluation_dir() / "calyx-xilinx-ultrascale-plus" / "bin" / "fud"
    )

    for futil_filepath in (calyx_path / "tests" / "correctness").glob("**/*.futil"):
        relative_dir_in_calyx = futil_filepath.parent.relative_to(calyx_path)
        compiled_sv_filepath = (
            output_base_dir
            / "compiled_with_futil"
            / relative_dir_in_calyx
            / f"{futil_filepath.stem}.sv"
        )
        synth_opt_place_route_output_filepath = (
            output_base_dir
            / "synthesis_results"
            / relative_dir_in_calyx
            / f"{futil_filepath.stem}.sv"
        )
        log_filepath = (
            output_base_dir
            / "synthesis_results"
            / relative_dir_in_calyx
            / f"{futil_filepath.stem}.log"
        )

        # Filepath with / replaced with _
        file_identifier = str(futil_filepath.relative_to(calyx_path)).replace("/", "_")

        # Task to build the file with fud. (.futil -> .sv)
        yield {
            "name": f"futil_build_{file_identifier}",
            "file_dep": [futil_filepath],
            "targets": [compiled_sv_filepath],
            "actions": [
                (compile_with_fud, [fud_filepath, futil_filepath, compiled_sv_filepath])
            ],
        }

        # Task to synthesize the file with Vivado. (.sv -> .sv, synthesized)
        yield {
            "name": f"synthesize_{file_identifier}",
            "actions": [
                (
                    xilinx_ultrascale_plus_vivado_synthesis,
                    [
                        compiled_sv_filepath,
                        synth_opt_place_route_output_filepath,
                        "top",
                        log_filepath,
                    ],
                )
            ],
            "targets": [synth_opt_place_route_output_filepath, log_filepath],
            "file_dep": [compiled_sv_filepath],
        }


def task_vanilla_calyx_end_to_end():
    calyx_path = utils.lakeroad_evaluation_dir() / "calyx"
    output_base_dir = utils.output_dir() / "calyx_end_to_end" / "vanilla_calyx"
    fud_filepath = utils.lakeroad_evaluation_dir() / "calyx" / "bin" / "fud"

    futil_files = (
        list((calyx_path / "tests" / "correctness" / "exp").glob("**/*.futil"))
        + list(
            (calyx_path / "tests" / "correctness" / "ntt-pipeline").glob("**/*.futil")
        )
        + list(
            (calyx_path / "tests" / "correctness" / "numeric-types").glob("**/*.futil")
        )
        # + list((calyx_path / "tests" / "correctness" / "ref-cells").glob("**/*.futil"))
        + list((calyx_path / "tests" / "correctness" / "relay").glob("**/*.futil"))
        + list((calyx_path / "tests" / "correctness" / "systolic").glob("**/*.futil"))
        + list((calyx_path / "tests" / "correctness" / "tcam").glob("**/*.futil"))
    )

    for futil_filepath in futil_files:
        relative_dir_in_calyx = futil_filepath.parent.relative_to(calyx_path)
        compiled_sv_filepath = (
            output_base_dir
            / "compiled_with_futil"
            / relative_dir_in_calyx
            / f"{futil_filepath.stem}.sv"
        )
        synth_opt_place_route_sv_output_filepath = (
            output_base_dir
            / "synthesis_results"
            / relative_dir_in_calyx
            / f"{futil_filepath.stem}.sv"
        )
        synth_opt_place_route_json_output_filepath = (
            output_base_dir
            / "synthesis_results"
            / relative_dir_in_calyx
            / f"{futil_filepath.stem}.json"
        )
        yosys_log_filepath = (
            output_base_dir
            / "yosys_synthesis_results"
            / relative_dir_in_calyx
            / f"{futil_filepath.stem}_yosys.log"
        )
        nextpnr_log_filepath = (
            output_base_dir
            / "yosys_synthesis_results"
            / relative_dir_in_calyx
            / f"{futil_filepath.stem}_nextpnr.log"
        )

        # Filepath with / replaced with _
        file_identifier = str(futil_filepath.relative_to(calyx_path)).replace("/", "_")

        # Task to build the file with fud. (.futil -> .sv)
        yield {
            "name": f"futil_build_{file_identifier}",
            "file_dep": [futil_filepath],
            "targets": [compiled_sv_filepath],
            "actions": [
                (compile_with_fud, [fud_filepath, futil_filepath, compiled_sv_filepath])
            ],
        }

        # Task to synthesize the file with Yosys. (.sv -> .sv, synthesized)
        # Yosys synthesis is broken right now.
        # yield {
        #     "name": f"synthesize_yosys_{file_identifier}",
        #     "actions": [
        #         (
        #             lattice_ecp5_yosys_nextpnr_synthesis,
        #             [
        #                 compiled_sv_filepath,
        #                 "main",
        #                 synth_opt_place_route_sv_output_filepath,
        #                 synth_opt_place_route_json_output_filepath,
        #                 yosys_log_filepath,
        #                 nextpnr_log_filepath,
        #             ],
        #         )
        #     ],
        #     "targets": [
        #         synth_opt_place_route_sv_output_filepath,
        #         synth_opt_place_route_json_output_filepath,
        #         yosys_log_filepath,
        #         nextpnr_log_filepath,
        #     ],
        #     "file_dep": [compiled_sv_filepath],
        # }

        vivado_synth_opt_place_route_output_filepath = (
            output_base_dir
            / "vivado_synthesis_results"
            / relative_dir_in_calyx
            / f"{futil_filepath.stem}.sv"
        )
        vivado_log_filepath = (
            output_base_dir
            / "vivado_synthesis_results"
            / relative_dir_in_calyx
            / f"{futil_filepath.stem}.log"
        )

        # Task to synthesize the file with Vivado. (.sv -> .sv, synthesized)
        yield {
            "name": f"synthesize_{file_identifier}",
            "actions": [
                (
                    xilinx_ultrascale_plus_vivado_synthesis,
                    [
                        compiled_sv_filepath,
                        vivado_synth_opt_place_route_output_filepath,
                        "main",
                        vivado_log_filepath,
                    ],
                )
            ],
            "targets": [
                vivado_synth_opt_place_route_output_filepath,
                vivado_log_filepath,
            ],
            "file_dep": [compiled_sv_filepath],
        }
