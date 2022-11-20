"""Functions and tasks for gathering generated data."""


import dataclasses
import json
from pathlib import Path
import yaml
from typing import Dict, List, Union

import pandas as pd
import utils
from schema import *
import doit

# Paths to JSON files in the output directory, sorted in ascending order. These
# paths must be appended onto a path base to actually produce a valid path, e.g.:
# /path/to/my/output/calyx_end_to_end_xilinx_ultrascale_plus_presynth_vivado/iter2/ + <json_filepath>
json_filepaths: List[Path] = list(
    map(
        Path,
        [
            "synthesis_results/benchmarks/calyx_evaluation/polybench/linear-algebra-2mm.fuse/linear-algebra-2mm.json",
            "synthesis_results/benchmarks/calyx_evaluation/polybench/linear-algebra-3mm.fuse/linear-algebra-3mm.json",
            "synthesis_results/benchmarks/calyx_evaluation/polybench/linear-algebra-atax.fuse/linear-algebra-atax.json",
            "synthesis_results/benchmarks/calyx_evaluation/polybench/linear-algebra-bicg.fuse/linear-algebra-bicg.json",
            "synthesis_results/benchmarks/calyx_evaluation/polybench/linear-algebra-cholesky.fuse/linear-algebra-cholesky.json",
            "synthesis_results/benchmarks/calyx_evaluation/polybench/linear-algebra-doitgen.fuse/linear-algebra-doitgen.json",
            "synthesis_results/benchmarks/calyx_evaluation/polybench/linear-algebra-durbin.fuse/linear-algebra-durbin.json",
            "synthesis_results/benchmarks/calyx_evaluation/polybench/linear-algebra-gemm.fuse/linear-algebra-gemm.json",
            "synthesis_results/benchmarks/calyx_evaluation/polybench/linear-algebra-gemver.fuse/linear-algebra-gemver.json",
            "synthesis_results/benchmarks/calyx_evaluation/polybench/linear-algebra-gesummv.fuse/linear-algebra-gesummv.json",
            "synthesis_results/benchmarks/calyx_evaluation/polybench/linear-algebra-gramschmidt.fuse/linear-algebra-gramschmidt.json",
            "synthesis_results/benchmarks/calyx_evaluation/polybench/linear-algebra-lu.fuse/linear-algebra-lu.json",
            "synthesis_results/benchmarks/calyx_evaluation/polybench/linear-algebra-ludcmp.fuse/linear-algebra-ludcmp.json",
            "synthesis_results/benchmarks/calyx_evaluation/polybench/linear-algebra-mvt.fuse/linear-algebra-mvt.json",
            "synthesis_results/benchmarks/calyx_evaluation/polybench/linear-algebra-symm.fuse/linear-algebra-symm.json",
            "synthesis_results/benchmarks/calyx_evaluation/polybench/linear-algebra-syr2k.fuse/linear-algebra-syr2k.json",
            "synthesis_results/benchmarks/calyx_evaluation/polybench/linear-algebra-syrk.fuse/linear-algebra-syrk.json",
            "synthesis_results/benchmarks/calyx_evaluation/polybench/linear-algebra-trisolv.fuse/linear-algebra-trisolv.json",
            "synthesis_results/benchmarks/calyx_evaluation/polybench/linear-algebra-trmm.fuse/linear-algebra-trmm.json",
            "synthesis_results/benchmarks/calyx_evaluation/systolic-sources/gemm2.fuse/gemm2.json",
            "synthesis_results/benchmarks/calyx_evaluation/systolic-sources/gemm4.fuse/gemm4.json",
            "synthesis_results/benchmarks/calyx_evaluation/systolic-sources/gemm6.fuse/gemm6.json",
            "synthesis_results/benchmarks/calyx_evaluation/systolic-sources/gemm8.fuse/gemm8.json",
            "synthesis_results/benchmarks/calyx_tests/correctness/numeric-types/bitnum/binary-operators.futil/binary-operators.json",
            "synthesis_results/benchmarks/calyx_tests/correctness/numeric-types/bitnum/sqrt.futil/sqrt.json",
            "synthesis_results/benchmarks/calyx_tests/correctness/numeric-types/bitnum/std-sdiv.futil/std-sdiv.json",
            "synthesis_results/benchmarks/calyx_tests/correctness/numeric-types/fixed-point/binary-operators.futil/binary-operators.json",
            "synthesis_results/benchmarks/calyx_tests/correctness/numeric-types/fixed-point/sqrt.futil/sqrt.json",
            "synthesis_results/benchmarks/calyx_tests/correctness/numeric-types/fixed-point/std-fp-sdiv.futil/std-fp-sdiv.json",
        ],
    )
)


def gather_calyx_end_to_end_data_vivado(
    json_filepaths: List[Union[str, Path]]
) -> pd.DataFrame:
    """Collect results from Calyx end-to-end experiments.

    Args:
      json_filepaths: Filepaths of the JSON files containing the data extracted
        from Vivado logs, e.g. the JSON files in
        out/vanilla_calyx_vivado_end_to_end.

    Returns:
      pandas DataFrame of the data."""

    def _f(json_filepath):
        """Load JSON file to dict, add file identifier to dict, return dict."""
        with open(json_filepath) as f:
            d = json.load(f)
        # Get the directory which we will make the path relative to. If the output is in
        # /path/to/output/vanilla_calyx_end_to_end_vivado/benchmarks/calyx_evaluation/.../something.json
        # Then this should get /path/to/output/vanilla_calyx_end_to_end_vivado.
        relative_to_directory = next(
            x for x in Path(json_filepath).parents if x.name == "benchmarks"
        ).parent
        d["identifier"] = str(Path(json_filepath).relative_to(relative_to_directory))
        return d

    return pd.DataFrame(map(_f, json_filepaths))


def make_gather_calyx_end_to_end_results_task(
    output_dirpath: Union[str, Path], output_csv: Union[str, Path]
):
    """Creates DoIt task which gathers Calyx end-to-end results into a table.

    Args:
      output_dirpath: Path of the directory containing the output.
      output_csv: Location to write the output.
    """

    # Create the actual paths to the json files by concatenating the output
    # directory path to the json filepaths defined above.
    full_json_filepaths = [
        output_dirpath / json_filepath for json_filepath in json_filepaths
    ]

    def _impl():
        output_csv.parent.mkdir(exist_ok=True, parents=True)
        df = gather_calyx_end_to_end_data_vivado(full_json_filepaths)
        df.to_csv(output_csv)

    return {
        "file_dep": full_json_filepaths,
        "targets": [output_csv],
        "actions": [(_impl, [])],
    }


def disabled_task_gather_calyx_end_to_end_xilinx_ultrascale_plus_presynth_vivado_results_iter0():
    """Gather results of Calyx end-to-end experiments into a table."""
    return make_gather_calyx_end_to_end_results_task(
        output_dirpath=utils.output_dir()
        / "calyx_end_to_end_xilinx_ultrascale_plus_presynth_vivado"
        / "iter0",
        output_csv=(
            utils.output_dir()
            / "gathered_data"
            / "calyx_end_to_end_xilinx_ultrascale_plus_presynth_vivado_results_iter0.csv"
        ),
    )


def disabled_task_gather_calyx_end_to_end_xilinx_ultrascale_plus_presynth_vivado_results_iter1():
    """Gather results of Calyx end-to-end experiments into a table."""
    return make_gather_calyx_end_to_end_results_task(
        output_dirpath=utils.output_dir()
        / "calyx_end_to_end_xilinx_ultrascale_plus_presynth_vivado"
        / "iter1",
        output_csv=(
            utils.output_dir()
            / "gathered_data"
            / "calyx_end_to_end_xilinx_ultrascale_plus_presynth_vivado_results_iter1.csv"
        ),
    )


def disabled_task_gather_calyx_end_to_end_xilinx_ultrascale_plus_presynth_vivado_results_iter2():
    """Gather results of Calyx end-to-end experiments into a table."""
    return make_gather_calyx_end_to_end_results_task(
        output_dirpath=utils.output_dir()
        / "calyx_end_to_end_xilinx_ultrascale_plus_presynth_vivado"
        / "iter2",
        output_csv=(
            utils.output_dir()
            / "gathered_data"
            / "calyx_end_to_end_xilinx_ultrascale_plus_presynth_vivado_results_iter2.csv"
        ),
    )


def disabled_task_gather_calyx_end_to_end_xilinx_ultrascale_plus_no_presynth_results_iter0():
    """Gather results of Calyx end-to-end experiments into a table."""
    return make_gather_calyx_end_to_end_results_task(
        output_dirpath=utils.output_dir()
        / "calyx_end_to_end_xilinx_ultrascale_plus_no_presynth"
        / "iter0",
        output_csv=(
            utils.output_dir()
            / "gathered_data"
            / "calyx_end_to_end_xilinx_ultrascale_plus_no_presynth_results_iter0.csv"
        ),
    )


def disabled_task_gather_calyx_end_to_end_xilinx_ultrascale_plus_no_presynth_results_iter1():
    """Gather results of Calyx end-to-end experiments into a table."""
    return make_gather_calyx_end_to_end_results_task(
        output_dirpath=utils.output_dir()
        / "calyx_end_to_end_xilinx_ultrascale_plus_no_presynth"
        / "iter1",
        output_csv=(
            utils.output_dir()
            / "gathered_data"
            / "calyx_end_to_end_xilinx_ultrascale_plus_no_presynth_results_iter1.csv"
        ),
    )


def disable_task_gather_calyx_end_to_end_xilinx_ultrascale_plus_no_presynth_results_iter2():
    """Gather results of Calyx end-to-end experiments into a table."""
    return make_gather_calyx_end_to_end_results_task(
        output_dirpath=utils.output_dir()
        / "calyx_end_to_end_xilinx_ultrascale_plus_no_presynth"
        / "iter2",
        output_csv=(
            utils.output_dir()
            / "gathered_data"
            / "calyx_end_to_end_xilinx_ultrascale_plus_no_presynth_results_iter2.csv"
        ),
    )


instruction_names = (
    [f"add{n}_2" for n in [1, 2, 3, 4, 5, 6, 7, 8, 16, 32, 64]]
    + [f"and{n}_2" for n in [1, 2, 3, 4, 5, 6, 7, 8, 16, 32, 64]]
    + [f"eq{n}_2" for n in [1, 2, 3, 4, 5, 6, 7, 8, 16, 32, 64]]
    + [f"mul{n}_2" for n in [1, 2, 3, 4, 5, 6, 7, 8, 16, 32, 64]]
    + [f"mux{n}_3" for n in [1, 2, 3, 4, 5, 6, 7, 8, 16, 32, 64]]
    + [f"neq{n}_2" for n in [1, 2, 3, 4, 5, 6, 7, 8, 16, 32, 64]]
    + [f"not{n}_1" for n in [1, 2, 3, 4, 5, 6, 7, 8, 16, 32, 64]]
    + [f"or{n}_2" for n in [1, 2, 3, 4, 5, 6, 7, 8, 16, 32, 64]]
    + [f"or{n}_2" for n in [1, 2, 3, 4, 5, 6, 7, 8, 16, 32, 64]]
    + [f"sub{n}_2" for n in [1, 2, 3, 4, 5, 6, 7, 8, 16, 32, 64]]
    + [f"uge{n}_2" for n in [1, 2, 3, 4, 5, 6, 7, 8, 16, 32, 64]]
    + [f"ugt{n}_2" for n in [1, 2, 3, 4, 5, 6, 7, 8, 16, 32, 64]]
    + [f"ule{n}_2" for n in [1, 2, 3, 4, 5, 6, 7, 8, 16, 32, 64]]
    + [f"ult{n}_2" for n in [1, 2, 3, 4, 5, 6, 7, 8, 16, 32, 64]]
    + [f"xor{n}_2" for n in [1, 2, 3, 4, 5, 6, 7, 8, 16, 32, 64]]
)


def make_gather_instruction_synthesis_results_task(filenames, output_filepath):
    """"""

    def _impl():
        Path(output_filepath).parent.mkdir(parents=True, exist_ok=True)
        df = pd.DataFrame((json.load(open(filename)) for filename in filenames))
        df.to_csv(output_filepath)

    return {
        "actions": [
            (
                _impl,
                [],
            )
        ],
        "file_dep": filenames,
        "targets": [output_filepath],
    }


def task_gather_diamond_baseline_synthesis_results():
    filenames = list(
        map(
            lambda f: utils.output_dir() / "baseline" / "diamond" / f / f"{f}.json",
            instruction_names,
        )
    )
    return make_gather_instruction_synthesis_results_task(
        filenames,
        utils.output_dir() / "gathered_data" / "diamond_baseline.csv",
    )


def task_gather_vivado_baseline_synthesis_results():
    filenames = list(
        map(
            lambda f: utils.output_dir() / "baseline" / "vivado" / f / f"{f}.json",
            instruction_names,
        )
    )
    return make_gather_instruction_synthesis_results_task(
        filenames,
        utils.output_dir() / "gathered_data" / "vivado_baseline.csv",
    )


@doit.task_params(
    [
        {
            "name": "experiments_file",
            "default": str(utils.lakeroad_evaluation_dir() / "experiments.yaml"),
            "type": str,
        },
    ]
)
def task_gather_lakeroad_synthesis_results(
    experiments_file: str,
):
    with open(experiments_file) as f:
        experiments: List[LakeroadInstructionExperiment] = yaml.load(f, yaml.Loader)

    @dataclasses.dataclass
    class ExpectedInstruction:
        filepath: Union[Path, str]
        time_filepath: Union[Path, str]
        module_name: str
        template: str
        architecture: str

    expected_instructions = []
    for experiment in experiments:
        module_name = experiment.implementation_action.implementation_module_name
        template = experiment.implementation_action.template
        architecture = experiment.architecture

        if architecture == "xilinx_ultrascale_plus":
            # Vivado results.
            expected_instructions.append(
                ExpectedInstruction(
                    filepath=utils.output_dir()
                    / "lakeroad"
                    / architecture
                    / module_name
                    / template
                    / "vivado"
                    / f"{module_name}.json",
                    time_filepath=utils.output_dir()
                    / "lakeroad"
                    / architecture
                    / module_name
                    / template
                    / f"{module_name}.time",
                    module_name=module_name,
                    template=template,
                    architecture=architecture,
                )
            )
        elif architecture == "lattice_ecp5":
            # Diamond results.
            expected_instructions.append(
                ExpectedInstruction(
                    filepath=utils.output_dir()
                    / "lakeroad"
                    / architecture
                    / module_name
                    / template
                    / "diamond"
                    / f"{module_name}.json",
                    time_filepath=utils.output_dir()
                    / "lakeroad"
                    / architecture
                    / module_name
                    / template
                    / f"{module_name}.time",
                    module_name=module_name,
                    template=template,
                    architecture=architecture,
                )
            )

    def impl(expected_instructions: List[ExpectedInstruction], output_filepath):
        Path(output_filepath).parent.mkdir(parents=True, exist_ok=True)
        rows: List[Dict] = []
        for expected_instruction in expected_instructions:
            data = json.loads(open(expected_instruction.filepath).read())
            data["module_name"] = expected_instruction.module_name
            data["architecture"] = expected_instruction.architecture
            data["template"] = expected_instruction.template
            data["lakeroad_runtime_s"] = float(
                open(expected_instruction.time_filepath).read().replace("s", "")
            )
            rows.append(data)
        pd.DataFrame(rows).to_csv(output_filepath)

    yield {
        "name": "xilinx_ultrascale_plus_vivado",
        "actions": [
            (
                impl,
                [],
                {
                    "expected_instructions": [
                        i
                        for i in expected_instructions
                        if i.architecture == "xilinx_ultrascale_plus"
                    ],
                    "output_filepath": utils.output_dir()
                    / "gathered_data"
                    / "lakeroad_xilinx_ultrascale_plus_vivado_results.csv",
                },
            )
        ],
        "file_dep": [
            expected_instruction.filepath
            for expected_instruction in expected_instructions
        ],
        "targets": [
            utils.output_dir()
            / "gathered_data"
            / "lakeroad_xilinx_ultrascale_plus_vivado_results.csv"
        ],
    }

    yield {
        "name": "lattice_ecp5_diamond",
        "actions": [
            (
                impl,
                [],
                {
                    "expected_instructions": [
                        i
                        for i in expected_instructions
                        if i.architecture == "lattice_ecp5"
                    ],
                    "output_filepath": utils.output_dir()
                    / "gathered_data"
                    / "lakeroad_lattice_ecp5_diamond_results.csv",
                },
            )
        ],
        "file_dep": [
            expected_instruction.filepath
            for expected_instruction in expected_instructions
        ],
        "targets": [
            utils.output_dir()
            / "gathered_data"
            / "lakeroad_lattice_ecp5_diamond_results.csv",
        ],
    }
