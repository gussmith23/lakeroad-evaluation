"""DoIt tasks for creating figures and tables."""

import functools
import json
from pathlib import Path
from matplotlib.axes import Axes
from typing import Dict, List, Union
import matplotlib.pyplot as plt
import numpy as np

# These paths can be used to find all of the results of our end-to-end
# compilation experiments. Each path just needs to be prepended with the output
# directory and the experiment you're looking for, e.g.
# vanilla_calyx_vivado_end_to_end. We use these to build our comparisons of the
# different Calyxes.
e2e_filepaths_to_compare = list(
    map(
        Path,
        [
            "synthesis_results/calyx-evaluation/benchmarks/unrolled/linear-algebra-syr2k.fuse/linear-algebra-syr2k.json",
            "synthesis_results/calyx-evaluation/benchmarks/unrolled/linear-algebra-2mm.fuse/linear-algebra-2mm.json",
            "synthesis_results/calyx-evaluation/benchmarks/unrolled/linear-algebra-gemm.fuse/linear-algebra-gemm.json",
            "synthesis_results/calyx-evaluation/benchmarks/unrolled/linear-algebra-gramschmidt.fuse/linear-algebra-gramschmidt.json",
            "synthesis_results/calyx-evaluation/benchmarks/unrolled/linear-algebra-gemver.fuse/linear-algebra-gemver.json",
            "synthesis_results/calyx-evaluation/benchmarks/unrolled/linear-algebra-doitgen.fuse/linear-algebra-doitgen.json",
            "synthesis_results/calyx-evaluation/benchmarks/unrolled/linear-algebra-3mm.fuse/linear-algebra-3mm.json",
            "synthesis_results/calyx-evaluation/benchmarks/unrolled/linear-algebra-syrk.fuse/linear-algebra-syrk.json",
            "synthesis_results/calyx-evaluation/benchmarks/unrolled/linear-algebra-gesummv.fuse/linear-algebra-gesummv.json",
            "synthesis_results/calyx-evaluation/benchmarks/unrolled/linear-algebra-atax.fuse/linear-algebra-atax.json",
            "synthesis_results/calyx-evaluation/benchmarks/polybench/linear-algebra-lu.fuse/linear-algebra-lu.json",
            "synthesis_results/calyx-evaluation/benchmarks/polybench/linear-algebra-bicg.fuse/linear-algebra-bicg.json",
            "synthesis_results/calyx-evaluation/benchmarks/polybench/linear-algebra-syr2k.fuse/linear-algebra-syr2k.json",
            "synthesis_results/calyx-evaluation/benchmarks/polybench/linear-algebra-2mm.fuse/linear-algebra-2mm.json",
            "synthesis_results/calyx-evaluation/benchmarks/polybench/linear-algebra-gemm.fuse/linear-algebra-gemm.json",
            "synthesis_results/calyx-evaluation/benchmarks/polybench/linear-algebra-gramschmidt.fuse/linear-algebra-gramschmidt.json",
            "synthesis_results/calyx-evaluation/benchmarks/polybench/linear-algebra-durbin.fuse/linear-algebra-durbin.json",
            "synthesis_results/calyx-evaluation/benchmarks/polybench/linear-algebra-mvt.fuse/linear-algebra-mvt.json",
            "synthesis_results/calyx-evaluation/benchmarks/polybench/linear-algebra-gemver.fuse/linear-algebra-gemver.json",
            "synthesis_results/calyx-evaluation/benchmarks/polybench/linear-algebra-ludcmp.fuse/linear-algebra-ludcmp.json",
            "synthesis_results/calyx-evaluation/benchmarks/polybench/linear-algebra-trmm.fuse/linear-algebra-trmm.json",
            "synthesis_results/calyx-evaluation/benchmarks/polybench/linear-algebra-doitgen.fuse/linear-algebra-doitgen.json",
            "synthesis_results/calyx-evaluation/benchmarks/polybench/linear-algebra-trisolv.fuse/linear-algebra-trisolv.json",
            "synthesis_results/calyx-evaluation/benchmarks/polybench/linear-algebra-symm.fuse/linear-algebra-symm.json",
            "synthesis_results/calyx-evaluation/benchmarks/polybench/linear-algebra-cholesky.fuse/linear-algebra-cholesky.json",
            "synthesis_results/calyx-evaluation/benchmarks/polybench/linear-algebra-3mm.fuse/linear-algebra-3mm.json",
            "synthesis_results/calyx-evaluation/benchmarks/polybench/linear-algebra-syrk.fuse/linear-algebra-syrk.json",
            "synthesis_results/calyx-evaluation/benchmarks/polybench/linear-algebra-gesummv.fuse/linear-algebra-gesummv.json",
            "synthesis_results/calyx-evaluation/benchmarks/polybench/linear-algebra-atax.fuse/linear-algebra-atax.json",
            "synthesis_results/calyx-evaluation/benchmarks/systolic-sources/gemm8.fuse/gemm8.json",
            "synthesis_results/calyx-evaluation/benchmarks/systolic-sources/gemm6.fuse/gemm6.json",
            "synthesis_results/calyx-evaluation/benchmarks/systolic-sources/gemm4.fuse/gemm4.json",
            "synthesis_results/calyx-evaluation/benchmarks/systolic-sources/gemm2.fuse/gemm2.json",
            "synthesis_results/calyx/tests/correctness/numeric-types/fixed-point/constants.futil/constants.json",
            "synthesis_results/calyx/tests/correctness/numeric-types/fixed-point/std-fp-sdiv.futil/std-fp-sdiv.json",
            "synthesis_results/calyx/tests/correctness/numeric-types/fixed-point/binary-operators.futil/binary-operators.json",
            "synthesis_results/calyx/tests/correctness/numeric-types/fixed-point/sqrt.futil/sqrt.json",
            "synthesis_results/calyx/tests/correctness/numeric-types/parsing/unsigned-fp.futil/unsigned-fp.json",
            "synthesis_results/calyx/tests/correctness/numeric-types/parsing/signed-bitnum.futil/signed-bitnum.json",
            "synthesis_results/calyx/tests/correctness/numeric-types/parsing/signed-fp.futil/signed-fp.json",
            "synthesis_results/calyx/tests/correctness/numeric-types/parsing/unsigned-bitnum.futil/unsigned-bitnum.json",
            "synthesis_results/calyx/tests/correctness/numeric-types/bitnum/std-sdiv.futil/std-sdiv.json",
            "synthesis_results/calyx/tests/correctness/numeric-types/bitnum/binary-operators.futil/binary-operators.json",
            "synthesis_results/calyx/tests/correctness/numeric-types/bitnum/sqrt.futil/sqrt.json",
        ],
    )
)


def _plot_clb_resources(
    ax: Axes,
    clb_resources: Dict,
):
    bars = [
        ("LUTs", clb_resources["CLB LUTs"]),
        ("Regs", clb_resources["CLB Registers"]),
        (
            "Muxes",
            clb_resources["F7 Muxes"][0]
            + clb_resources["F8 Muxes"][0]
            + clb_resources["F9 Muxes"][0],
        ),
    ]
    ax.bar([v[0] for v in bars], [v[1] for v in bars])


def _plot_vivado_synthesis_time_comparison(
    ax: Axes, names: List[str], filepaths: List[Union[Path, str]]
):
    """Plot a comparison of the synthesis times in the given files."""
    assert len(names) == len(filepaths)

    def _f(filepath):
        """Open a filepath, parse JSON, and read out the synthesis time."""
        with open(filepath) as f:
            j = json.load(f)
        return j["synth_time"]

    ax.bar(names, [_f(filepath) for filepath in filepaths])


def _plot_vivado_synthesis_times(
    filepath_lists: List[List[Union[Path, str]]], width: float = 0.35
):
    """Create a plot comparing Vivado synthesis times.

    Args:
        filepath_lists: Lists of lists of filepaths. The nth entry from each
        list will be plotted next to each other in the resulting plot."""
    assert len(filepath_lists) > 0

    # Number of groups of bars.
    num_groups = len(filepath_lists[0])
    bars_per_group = len(filepath_lists)

    # Check that all lists are the same length.
    for l in filepath_lists:
        assert len(l) == num_groups

    fig, ax = plt.subplots()

    x = np.arange(num_groups)

    def _f(filepath):
        """Open a filepath, parse JSON, and read out the synthesis time."""
        with open(filepath) as f:
            j = json.load(f)
        return j["synth_time"]

    for i, filepaths in enumerate(filepath_lists):
        ax.bar(
            x + i * width,
            [_f(filepath) for filepath in filepaths],
            width,
        )

    return fig


def task_e2e_comparison():
    pass
