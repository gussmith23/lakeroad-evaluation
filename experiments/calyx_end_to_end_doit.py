#!/usr/bin/env python3
import utils
from pathlib import Path
import logging
import os
import subprocess
from typing import Literal, Optional, Union
from experiment import Experiment
from hardware_compilation import (
    lattice_ecp5_yosys_nextpnr_synthesis,
    xilinx_ultrascale_plus_vivado_synthesis,
)
import doit


class CalyxEndToEnd(Experiment):
    """Runs Calyx compilation and hardware synthesis on all backends.

    This experiment simply runs the _CalyxEndToEndSingleBackend experiment on
    each backend. See sub-experiment classes for details."""

    def __init__(
        self,
        output_dir: Union[str, Path],
        vanilla_calyx_dir: Optional[Union[str, Path]] = None,
        vanilla_fud_path: Optional[Union[str, Path]] = None,
        xilinx_ultrascale_plus_calyx_dir: Optional[Union[str, Path]] = None,
        xilinx_ultrascale_plus_fud_path: Optional[Union[str, Path]] = None,
        lattice_ecp5_calyx_dir: Optional[Union[str, Path]] = None,
        lattice_ecp5_fud_path: Optional[Union[str, Path]] = None,
        overwrite_output_dir: bool = False,
    ):
        super().__init__()
        self._output_dir = Path(output_dir)
        self._overwrite_output_dir = overwrite_output_dir

        if vanilla_calyx_dir is not None and vanilla_fud_path is not None:
            self.register(
                _CalyxEndToEndExperimentSingleBackend(
                    output_dir=self._output_dir / "vanilla",
                    calyx_path=vanilla_calyx_dir,
                    fud_path=vanilla_fud_path,
                    overwrite_output_dir=overwrite_output_dir,
                )
            )
        if (
            xilinx_ultrascale_plus_calyx_dir is not None
            and xilinx_ultrascale_plus_fud_path is not None
        ):
            self.register(
                _CalyxEndToEndExperimentSingleBackend(
                    output_dir=self._output_dir / "xilinx_ultrascale_plus",
                    calyx_path=xilinx_ultrascale_plus_calyx_dir,
                    fud_path=xilinx_ultrascale_plus_fud_path,
                    overwrite_output_dir=overwrite_output_dir,
                )
            )
        if lattice_ecp5_calyx_dir is not None and lattice_ecp5_fud_path is not None:
            self.register(
                _CalyxEndToEndExperimentSingleBackend(
                    output_dir=self._output_dir / "lattice_ecp5",
                    calyx_path=lattice_ecp5_calyx_dir,
                    fud_path=lattice_ecp5_fud_path,
                    overwrite_output_dir=overwrite_output_dir,
                )
            )


class _CalyxEndToEndExperimentSingleBackend(Experiment):
    """Compiles Calyx .futil files and runs hardware synthesis on results."""

    def __init__(
        self,
        output_dir: Union[str, Path],
        calyx_path: Union[str, Path],
        fud_path: Union[str, Path],
        backend: Union[
            Literal["xilinx_ultrascale_plus"], Literal["lattice_ecp5"], Literal["sofa"]
        ],
        overwrite_output_dir: bool = False,
    ) -> None:
        super().__init__()
        self._output_dir = Path(output_dir)
        self._overwrite_output_dir = overwrite_output_dir

        compiled_with_calyx_dir = (self._output_dir / "futil_files_compiled_with_fud",)

        self.register(
            _CompileCalyxFutilFilesWithFud(
                output_dir=compiled_with_calyx_dir,
                calyx_path=calyx_path,
                fud_path=fud_path,
                overwrite_output_dir=overwrite_output_dir,
            )
        )

        self.register(
            _RunHardwareSynthesisOnCompiledCalyxFiles(
                output_dir=self._output_dir / "hardware_synthesis_results",
                overwrite_output_dir=overwrite_output_dir,
                compiled_with_calyx_dir=compiled_with_calyx_dir,
                backend=backend,
            )
        )

    def _run_experiment(self):
        super()._run_experiment()
        self._output_dir.mkdir(parents=True, exist_ok=self._overwrite_output_dir)


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


class _CompileCalyxFutilFilesWithFud(Experiment):
    """Compile the .futil files in Calyx.

    Given a path to a Calyx repository and a path to a fud binary, this
    experiment compiles the .futil files found within the Calyx directory (and
    subdirectories) and writes the resulting Verilog to the output directory."""

    def __init__(
        self,
        output_dir: Union[str, Path],
        calyx_path: Union[str, Path],
        fud_path: Union[str, Path],
        overwrite_output_dir: bool = False,
    ) -> None:
        """Constructor.

        Args:
            output_dir: The directory to write the Verilog files to.
            calyx_path: The path to the Calyx repository.
            fud_path: The path to the fud binary.
            overwrite_output_dir: Whether to overwrite the output directory."""
        super().__init__()
        self._output_dir = output_dir
        self._overwrite_output_dir = overwrite_output_dir
        self._calyx_path = calyx_path
        self._fud_path = fud_path

    @property
    def compiled_with_calyx_dir(self) -> Path:
        return self._compiled_with_calyx_dir

    def _run_experiment(self):
        self._output_dir.mkdir(parents=True, exist_ok=self._overwrite_output_dir)
        # TODO(@gussmith23): ignore ref-cells.
        # futil_files=$(find $BASE_DIR/calyx/tests/correctness/ \( -name '*.futil' ! -wholename '*ref-cells/*' \) )
        for futil_file in (self._calyx_path / "tests" / "correctness").glob(
            "**/*.futil"
        ):
            with open(self._output_dir / f"{futil_file.stem}.sv", "w") as f:
                f.write(
                    compile_with_fud(fud_path=self._fud_path, futil_filepath=futil_file)
                )


# TODO(@gussmith23): We should just reuse existing hardware synthesis
# experiment. Instead, we're basically reimplementing it.
class _RunHardwareSynthesisOnCompiledCalyxFiles(Experiment):
    def __init__(
        self,
        output_dir: Union[str, Path],
        compiled_with_calyx_dir: Union[str, Path],
        backend: Union[
            Literal["xilinx_ultrascale_plus"], Literal["lattice_ecp5"], Literal["sofa"]
        ],
        overwrite_output_dir: bool = False,
    ) -> None:
        super().__init__()
        self._output_dir = output_dir
        self._overwrite_output_dir = overwrite_output_dir
        self._compiled_with_calyx_dir = compiled_with_calyx_dir
        self._backend = backend

    @property
    def compiled_with_calyx_dir(self) -> Path:
        return self._compiled_with_calyx_dir

    def _run_experiment(self):
        self._output_dir.mkdir(parents=True, exist_ok=self._overwrite_output_dir)

        for compiled_file in (self._compiled_with_calyx_dir).glob("*.sv"):
            if self._backend == "xilinx_ultrascale_plus":
                xilinx_ultrascale_plus_vivado_synthesis(
                    compiled_file,
                    output_files_filename_base=self._output_dir / compiled_file.stem,
                    module_name=compiled_file.stem,
                )
            elif self._backend == "lattice_ecp5":
                lattice_ecp5_yosys_nextpnr_synthesis(
                    instr_src_file=compiled_file,
                    output_files_filename_base=self._output_dir / compiled_file.stem,
                    module_name=compiled_file.stem,
                )
            else:
                raise NotImplementedError(f"Backend {self._backend} not implemented.")


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


@doit.task_params(
    [
        {"name": "output_dir", "default": "out", "type": str},
    ]
)
def task_lattice_ecp5_calyx_end_to_end(output_dir):
    output_dir = Path(output_dir)

    calyx_path = utils.lakeroad_evaluation_dir() / "calyx-lattice-ecp5"
    output_base_dir = output_dir / "calyx_end_to_end" / "lattice_ecp5"
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


@doit.task_params(
    [
        {"name": "output_dir", "default": "out", "type": str},
    ]
)
def task_xilinx_ultrascale_plus_calyx_end_to_end(output_dir):
    output_dir = Path(output_dir)

    calyx_path = utils.lakeroad_evaluation_dir() / "calyx-xilinx-ultrascale-plus"
    output_base_dir = output_dir / "calyx_end_to_end" / "xilinx_ultrascale_plus"
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

@doit.task_params(
    [
        {"name": "output_dir", "default": "out", "type": str},
    ]
)
def task_vanilla_calyx_end_to_end(output_dir):
    output_dir = Path(output_dir)

    calyx_path = utils.lakeroad_evaluation_dir() / "calyx"
    output_base_dir = output_dir / "calyx_end_to_end" / "vanilla_calyx"
    fud_filepath = (
        utils.lakeroad_evaluation_dir() / "calyx" / "bin" / "fud"
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
                    "main",
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



if __name__ == "__main__":
    import argparse

    logging.basicConfig(level=os.environ.get("LOGLEVEL", "WARNING"))

    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--output-dir",
        help="Output directory.",
        required=True,
        type=Path,
    )
    parser.add_argument(
        "--vanilla-calyx-dir",
        help='Directory of "vanilla", i.e. unmodified, Calyx.',
        required=False,
        type=Path,
    )
    parser.add_argument(
        "--vanilla-fud-path",
        help="Path to vanilla fud binary",
        required=False,
        type=Path,
    )
    parser.add_argument(
        "--xilinx-ultrascale-plus-calyx-dir",
        help="Directory of the Xilinx UltraScale+ Calyx instance.",
        required=False,
        type=Path,
    )
    parser.add_argument(
        "--xilinx-ultrascale-plus-fud-path",
        help="Path to Xilinx UltraScale+ Calyx instance's fud binary",
        required=False,
        type=Path,
    )
    parser.add_argument(
        "--lattice-ecp5-calyx-dir",
        help="Directory of the Lattice ECP5 Calyx instance.",
        required=False,
        type=Path,
    )
    parser.add_argument(
        "--lattice-ecp5-fud-path",
        help="Path to Lattice ECP5 Calyx instance's fud binary",
        required=False,
        type=Path,
    )
    parser.add_argument(
        "--overwrite-output-dir",
        help="Whether or not to overwrite the output dir, if it exists.",
        default=False,
        action=argparse.BooleanOptionalAction,
    )
    args = parser.parse_args()

    # Construct and run the top-level experiment.
    CalyxEndToEnd(**vars(args)).run()
