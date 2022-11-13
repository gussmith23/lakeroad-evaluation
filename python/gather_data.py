"""Functions and tasks for gathering generated data."""


import functools
import json
from pathlib import Path
from typing import List, Union

import pandas as pd
import utils

# Paths to JSON files in the output directory. These paths must be appended onto
# a path base to actually produce a valid path, e.g.
# /path/to/my/output/calyx_end_to_end_xilinx_ultrascale_plus_presynth_vivado/iter2/ + <json_filepath>
json_filepaths: List[Path] = list(
    map(
        Path,
        [
            "synthesis_results/benchmarks/calyx_evaluation/unrolled/linear-algebra-syr2k.fuse/linear-algebra-syr2k.json",
            "synthesis_results/benchmarks/calyx_evaluation/unrolled/linear-algebra-2mm.fuse/linear-algebra-2mm.json",
            "synthesis_results/benchmarks/calyx_evaluation/unrolled/linear-algebra-gemm.fuse/linear-algebra-gemm.json",
            "synthesis_results/benchmarks/calyx_evaluation/unrolled/linear-algebra-gramschmidt.fuse/linear-algebra-gramschmidt.json",
            "synthesis_results/benchmarks/calyx_evaluation/unrolled/linear-algebra-gemver.fuse/linear-algebra-gemver.json",
            "synthesis_results/benchmarks/calyx_evaluation/unrolled/linear-algebra-doitgen.fuse/linear-algebra-doitgen.json",
            "synthesis_results/benchmarks/calyx_evaluation/unrolled/linear-algebra-3mm.fuse/linear-algebra-3mm.json",
            "synthesis_results/benchmarks/calyx_evaluation/unrolled/linear-algebra-syrk.fuse/linear-algebra-syrk.json",
            "synthesis_results/benchmarks/calyx_evaluation/unrolled/linear-algebra-gesummv.fuse/linear-algebra-gesummv.json",
            "synthesis_results/benchmarks/calyx_evaluation/unrolled/linear-algebra-atax.fuse/linear-algebra-atax.json",
            "synthesis_results/benchmarks/calyx_evaluation/polybench/linear-algebra-lu.fuse/linear-algebra-lu.json",
            "synthesis_results/benchmarks/calyx_evaluation/polybench/linear-algebra-bicg.fuse/linear-algebra-bicg.json",
            "synthesis_results/benchmarks/calyx_evaluation/polybench/linear-algebra-syr2k.fuse/linear-algebra-syr2k.json",
            "synthesis_results/benchmarks/calyx_evaluation/polybench/linear-algebra-2mm.fuse/linear-algebra-2mm.json",
            "synthesis_results/benchmarks/calyx_evaluation/polybench/linear-algebra-gemm.fuse/linear-algebra-gemm.json",
            "synthesis_results/benchmarks/calyx_evaluation/polybench/linear-algebra-gramschmidt.fuse/linear-algebra-gramschmidt.json",
            "synthesis_results/benchmarks/calyx_evaluation/polybench/linear-algebra-durbin.fuse/linear-algebra-durbin.json",
            "synthesis_results/benchmarks/calyx_evaluation/polybench/linear-algebra-mvt.fuse/linear-algebra-mvt.json",
            "synthesis_results/benchmarks/calyx_evaluation/polybench/linear-algebra-gemver.fuse/linear-algebra-gemver.json",
            "synthesis_results/benchmarks/calyx_evaluation/polybench/linear-algebra-ludcmp.fuse/linear-algebra-ludcmp.json",
            "synthesis_results/benchmarks/calyx_evaluation/polybench/linear-algebra-trmm.fuse/linear-algebra-trmm.json",
            "synthesis_results/benchmarks/calyx_evaluation/polybench/linear-algebra-doitgen.fuse/linear-algebra-doitgen.json",
            "synthesis_results/benchmarks/calyx_evaluation/polybench/linear-algebra-trisolv.fuse/linear-algebra-trisolv.json",
            "synthesis_results/benchmarks/calyx_evaluation/polybench/linear-algebra-symm.fuse/linear-algebra-symm.json",
            "synthesis_results/benchmarks/calyx_evaluation/polybench/linear-algebra-cholesky.fuse/linear-algebra-cholesky.json",
            "synthesis_results/benchmarks/calyx_evaluation/polybench/linear-algebra-3mm.fuse/linear-algebra-3mm.json",
            "synthesis_results/benchmarks/calyx_evaluation/polybench/linear-algebra-syrk.fuse/linear-algebra-syrk.json",
            "synthesis_results/benchmarks/calyx_evaluation/polybench/linear-algebra-gesummv.fuse/linear-algebra-gesummv.json",
            "synthesis_results/benchmarks/calyx_evaluation/polybench/linear-algebra-atax.fuse/linear-algebra-atax.json",
            "synthesis_results/benchmarks/calyx_evaluation/systolic-sources/gemm8.fuse/gemm8.json",
            "synthesis_results/benchmarks/calyx_evaluation/systolic-sources/gemm6.fuse/gemm6.json",
            "synthesis_results/benchmarks/calyx_evaluation/systolic-sources/gemm4.fuse/gemm4.json",
            "synthesis_results/benchmarks/calyx_evaluation/systolic-sources/gemm2.fuse/gemm2.json",
            "synthesis_results/benchmarks/calyx_tests/correctness/numeric-types/fixed-point/constants.futil/constants.json",
            "synthesis_results/benchmarks/calyx_tests/correctness/numeric-types/fixed-point/std-fp-sdiv.futil/std-fp-sdiv.json",
            "synthesis_results/benchmarks/calyx_tests/correctness/numeric-types/fixed-point/binary-operators.futil/binary-operators.json",
            "synthesis_results/benchmarks/calyx_tests/correctness/numeric-types/fixed-point/sqrt.futil/sqrt.json",
            "synthesis_results/benchmarks/calyx_tests/correctness/numeric-types/parsing/unsigned-fp.futil/unsigned-fp.json",
            "synthesis_results/benchmarks/calyx_tests/correctness/numeric-types/parsing/signed-bitnum.futil/signed-bitnum.json",
            "synthesis_results/benchmarks/calyx_tests/correctness/numeric-types/parsing/signed-fp.futil/signed-fp.json",
            "synthesis_results/benchmarks/calyx_tests/correctness/numeric-types/parsing/unsigned-bitnum.futil/unsigned-bitnum.json",
            "synthesis_results/benchmarks/calyx_tests/correctness/numeric-types/bitnum/std-sdiv.futil/std-sdiv.json",
            "synthesis_results/benchmarks/calyx_tests/correctness/numeric-types/bitnum/binary-operators.futil/binary-operators.json",
            "synthesis_results/benchmarks/calyx_tests/correctness/numeric-types/bitnum/sqrt.futil/sqrt.json",
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


def task_gather_calyx_end_to_end_xilinx_ultrascale_plus_presynth_vivado_results():
    # Number of iters run for this experiment. Should really be set in a config
    # somewhere.
    iters = 3

    output_csv = (
        utils.output_dir()
        / "gathered_data"
        / "calyx_end_to_end_xilinx_ultrascale_plus_presynth_vivado_results.csv"
    )

    # Collecting all the filenames for all the JSON files produced by all the
    # iters in one list of lists.
    json_filepaths_from_each_iter: List[List[Union[Path, str]]] = []
    for i in range(iters):
        json_filepaths_from_each_iter.append(
            [
                utils.output_dir()
                / "calyx_end_to_end_xilinx_ultrascale_plus_presynth_vivado"
                / f"iter{i}"
                / json_filepath
                for json_filepath in json_filepaths
            ]
        )

    def _impl():

        dfs: List[pd.DataFrame] = []
        for i, l in enumerate(json_filepaths_from_each_iter):
            df = gather_calyx_end_to_end_data_vivado(l)
            df.insert(0, "iteration", i)
            dfs.append(df)

        df = pd.concat(dfs)
        df.to_csv(output_csv)

    return {
        "file_dep": sum(json_filepaths_from_each_iter, []),
        "targets": [output_csv],
        "actions": [(_impl, [])],
    }
