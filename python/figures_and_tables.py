"""DoIt tasks for creating paper figures and tables."""

import doit
import pandas as pd
import utils
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


@doit.task_params(
    [
        {
            "name": "gathered_data_filepath",
            "default": str(
                utils.output_dir() / "gathered_data" / "lakeroad_sofa_results.csv"
            ),
            "type": str,
        },
        {
            "name": "csv_filepath",
            "default": str(utils.output_dir() / "figures" / "sofa_figure.csv"),
            "type": str,
        },
        {
            "name": "tex_filepath",
            "default": str(utils.output_dir() / "figures" / "sofa_figure.tex"),
            "type": str,
        },
        {
            "name": "excel_filepath",
            "default": str(utils.output_dir() / "figures" / "sofa_figure.xlsx"),
            "type": str,
        },
    ]
)
def task_make_sofa_figure(
    gathered_data_filepath: Union[str, Path],
    csv_filepath: Union[str, Path],
    tex_filepath: Union[str, Path],
    excel_filepath: Union[str, Path],
):
    gathered_data_filepath = Path(gathered_data_filepath)
    csv_filepath = Path(csv_filepath)
    tex_filepath = Path(tex_filepath)
    excel_filepath = Path(excel_filepath)

    instruction_col = ("", "", "Instr")
    template_col = ("", "", "Template")
    lakeroad_runtime_col = ("SOFA", "Lakeroad", "Runtime in sec")
    lakeroad_num_luts_col = ("SOFA", "Lakeroad", "#LUTs")
    diamond_support_col = ("SOFA", "Diamond", "Support")
    vivado_support_col = ("SOFA", "Vivado", "Support")

    columns = pd.MultiIndex.from_tuples(
        [
            instruction_col,
            template_col,
            lakeroad_runtime_col,
            lakeroad_num_luts_col,
            diamond_support_col,
            vivado_support_col,
        ]
    )

    def _impl():
        csv_filepath.parent.mkdir(parents=True, exist_ok=True)
        tex_filepath.parent.mkdir(parents=True, exist_ok=True)
        excel_filepath.parent.mkdir(parents=True, exist_ok=True)

        data = pd.read_csv(gathered_data_filepath)
        table = pd.DataFrame(columns=columns)

        def add_row(instr, arity, template):
            # Row of raw data that we'll convert into an output table row.
            raw_data_row = data.loc[
                (data["module_name"] == f"lakeroad_sofa_{instr}_{arity}")
                & (data["template"] == template)
            ].squeeze()

            match template:
                case "bitwise":
                    short_template = "BW"
                case "bitwise-with-carry":
                    short_template = "Carry"
                case "multiplication":
                    short_template = "Mult"
                case "comparison":
                    short_template = "Comp"
                case _:
                    raise Exception(f"Unknown template: {template}")
            out_row = pd.DataFrame(
                [
                    [
                        instr,
                        short_template,
                        raw_data_row["lakeroad_runtime_s"],
                        raw_data_row["frac_lut4"],
                        "X",
                        "X",
                    ]
                ],
                columns=columns,
            )
            nonlocal table
            table = pd.concat([table, out_row], ignore_index=True)

        add_row("and8", 2, "bitwise")
        add_row("and16", 2, "bitwise")
        add_row("and32", 2, "bitwise")
        add_row("or8", 2, "bitwise")
        add_row("or16", 2, "bitwise")
        add_row("or32", 2, "bitwise")
        add_row("xor8", 2, "bitwise")
        add_row("xor16", 2, "bitwise")
        add_row("xor32", 2, "bitwise")
        add_row("not8", 1, "bitwise")
        add_row("not16", 1, "bitwise")
        add_row("not32", 1, "bitwise")
        add_row("mux8", 3, "bitwise")
        add_row("mux16", 3, "bitwise")
        add_row("mux32", 3, "bitwise")
        add_row("add8", 2, "bitwise-with-carry")
        add_row("add16", 2, "bitwise-with-carry")
        add_row("add32", 2, "bitwise-with-carry")
        add_row("sub8", 2, "bitwise-with-carry")
        add_row("sub16", 2, "bitwise-with-carry")
        add_row("sub32", 2, "bitwise-with-carry")
        add_row("mul8", 2, "multiplication")
        table = pd.concat(
            [
                table,
                pd.DataFrame(
                    [
                        ["mul16", "-", "-", "-", "X", "X"],
                        ["mul32", "-", "-", "-", "X", "X"],
                    ],
                    columns=columns,
                ),
            ],
            ignore_index=True,
        )
        add_row("eq8", 2, "comparison")
        add_row("eq16", 2, "comparison")
        add_row("eq32", 2, "comparison")
        add_row("neq8", 2, "comparison")
        add_row("neq16", 2, "comparison")
        add_row("neq32", 2, "comparison")
        add_row("ugt8", 2, "comparison")
        add_row("ugt16", 2, "comparison")
        add_row("ugt32", 2, "comparison")
        add_row("ult8", 2, "comparison")
        add_row("ult16", 2, "comparison")
        add_row("ult32", 2, "comparison")
        add_row("uge8", 2, "comparison")
        add_row("uge16", 2, "comparison")
        add_row("uge32", 2, "comparison")
        add_row("ule8", 2, "comparison")
        add_row("ule16", 2, "comparison")
        add_row("ule32", 2, "comparison")

        table.to_csv(
            csv_filepath,
        )
        styler = table.style.format(precision=1).hide(axis="index")
        styler.to_latex(tex_filepath)
        styler.to_excel(excel_filepath)

    return {"actions": [(_impl,)], "file_dep": [gathered_data_filepath]}
