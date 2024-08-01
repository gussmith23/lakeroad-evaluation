from typing import Union

import doit
import yaml
import hardware_compilation
import lakeroad
import utils
import json
from typing import List
import pandas
import pandas as pd
import verilator
import quartus
import os
from pathlib import Path
import matplotlib.pyplot as plt
from matplotlib.gridspec import GridSpec
import numpy as np


def _lakeroad_is_X_times_better_numbers(
    xilinx_succeeded_vs_failed_csv: Union[str, Path],
    lattice_succeeded_vs_failed_csv: Union[str, Path],
    intel_succeeded_vs_failed_csv: Union[str, Path],
    output_csv: Union[str, Path],
):
    xilinx_df = pd.read_csv(xilinx_succeeded_vs_failed_csv)
    lattice_df = pd.read_csv(lattice_succeeded_vs_failed_csv)
    intel_df = pd.read_csv(intel_succeeded_vs_failed_csv)

    records = []
    for df, tools in [
        (xilinx_df, ["Xilinx SOTA", "Yosys"]),
        (lattice_df, ["Lattice SOTA", "Yosys"]),
        (intel_df, ["Intel SOTA", "Yosys"]),
    ]:
        for tool in tools:
            records.append(
                {
                    "tool": tool,
                    "lakeroad is __X times better than tool": (
                        df[df.tool == "Lakeroad"].squeeze().num_successful
                        / df[df.tool == tool].num_successful.squeeze()
                        if df[df.tool == tool].num_successful.squeeze() != 0
                        else np.inf
                    ),
                }
            )

    df = pd.DataFrame.from_records(records)
    Path(output_csv).parent.mkdir(parents=True, exist_ok=True)
    df.to_csv(output_csv)


def _solver_counts(input_csv, output_csv):
    df = pd.read_csv(input_csv)
    df = df[
        (df.tool == "lakeroad")
        & (df.lakeroad_synthesis_timeout == False)
        & (
            (df.lakeroad_synthesis_success == True)
            | (df.lakeroad_synthesis_failure == True)
        )
    ]
    df = df.groupby("solver").solver.count()
    Path(output_csv).parent.mkdir(parents=True, exist_ok=True)
    df.to_csv(output_csv)


def _timing_table(input_csv, output_csv):
    df = pd.read_csv(input_csv)

    df[df["tool"] == "vivado"].time_s.max()

    out_records = []
    for arch in ["xilinx-ultrascale-plus", "lattice-ecp5", "intel"]:
        if arch == "xilinx-ultrascale-plus":
            tools = ["vivado", "yosys", "lakeroad"]
        elif arch == "lattice-ecp5":
            tools = ["diamond", "yosys", "lakeroad"]
        elif arch == "intel":
            tools = ["quartus", "yosys", "lakeroad"]

        for tool in tools:
            out_records.append(
                {
                    "architecture": arch,
                    "tool": tool,
                    "median_time_s": df[
                        (df["architecture"] == arch) & (df["tool"] == tool)
                    ].time_s.median(),
                    "min_time_s": df[
                        (df["architecture"] == arch) & (df["tool"] == tool)
                    ].time_s.min(),
                    "max_time_s": df[
                        (df["architecture"] == arch) & (df["tool"] == tool)
                    ].time_s.max(),
                }
            )

    Path(output_csv).parent.mkdir(parents=True, exist_ok=True)
    pd.DataFrame(out_records).to_csv(output_csv)


def _resource_percentages(input_csv, output_csv):
    # read in a file called completeness.csv
    df = pd.read_csv(input_csv).fillna(0)

    def _compute_percentages(
        baseline_tool_name, architecture, logic_element_names, dsp_names, register_names
    ):
        baseline = df[
            (df["tool"] == baseline_tool_name) & (df["architecture"] == architecture)
        ]

        lakeroad_successes = df[
            (df["tool"] == "lakeroad")
            & (df["lakeroad_synthesis_success"] == True)
            & (df["architecture"] == architecture)
        ]
        merged = lakeroad_successes.merge(
            baseline, on="identifier", suffixes=("_lakeroad", f"_{baseline_tool_name}")
        )

        lakeroad_le_column_name = "lakeroad_LEs"
        baseline_le_column_name = f"{baseline_tool_name}_LEs"
        merged[lakeroad_le_column_name] = sum(
            merged[f"{name}_lakeroad"] for name in logic_element_names
        )
        merged[baseline_le_column_name] = sum(
            merged[f"{name}_{baseline_tool_name}"] for name in logic_element_names
        )

        lakeroad_dsp_column_name = "lakeroad_dsps"
        baseline_dsp_column_name = f"{baseline_tool_name}_dsps"
        merged[lakeroad_dsp_column_name] = sum(
            merged.get(f"{name}_lakeroad", default=0) for name in dsp_names
        )
        merged[baseline_dsp_column_name] = sum(
            merged.get(f"{name}_{baseline_tool_name}", default=0) for name in dsp_names
        )

        lakeroad_register_column_name = "lakeroad_registers"
        baseline_register_column_name = f"{baseline_tool_name}_registers"
        merged[lakeroad_register_column_name] = sum(
            merged.get(f"{name}_lakeroad", default=0) for name in register_names
        )
        merged[baseline_register_column_name] = sum(
            merged.get(f"{name}_{baseline_tool_name}", default=0)
            for name in register_names
        )

        merged["LE_difference"] = (
            merged[baseline_le_column_name] - merged[lakeroad_le_column_name]
        )
        merged["LE_percent_improvement"] = np.where(
            merged[baseline_le_column_name] > 0,
            (merged["LE_difference"] / merged[baseline_le_column_name]) * 100,
            0,
        )

        merged["DSP_difference"] = (
            merged[baseline_dsp_column_name] - merged[lakeroad_dsp_column_name]
        )
        merged["DSP_percent_improvement"] = np.where(
            merged[baseline_dsp_column_name] > 0,
            (merged["DSP_difference"] / merged[baseline_dsp_column_name]) * 100,
            0,
        )

        merged["register_difference"] = (
            merged[baseline_register_column_name]
            - merged[lakeroad_register_column_name]
        )
        merged["register_percent_improvement"] = np.where(
            merged[baseline_register_column_name] > 0,
            (merged["register_difference"] / merged[baseline_register_column_name])
            * 100,
            0,
        )

        return {
            "tool": baseline_tool_name,
            "architecture": architecture,
            "LE_percent_improvement_mean": merged["LE_percent_improvement"].mean(),
            "DSP_percent_improvement_mean": merged["DSP_percent_improvement"].mean(),
            "register_percent_improvement_mean": merged[
                "register_percent_improvement"
            ].mean(),
            "LE_difference_mean": merged["LE_difference"].mean(),
            "DSP_difference_mean": merged["DSP_difference"].mean(),
            "register_difference_mean": merged["register_difference"].mean(),
        }

    Path(output_csv).parent.mkdir(parents=True, exist_ok=True)
    pd.DataFrame.from_records(
        [
            _compute_percentages(
                "vivado",
                "xilinx-ultrascale-plus",
                [
                    "CARRY4",
                    "LUT2",
                    "LUT3",
                    "LUT4",
                    "LUT5",
                    "LUT6",
                    "SRL16E",
                    "MUXF7",
                    "MUXF8",
                    "MUXF9",
                ],
                ["DSP48E2"],
                ["FDRE"],
            ),
            _compute_percentages(
                "yosys",
                "xilinx-ultrascale-plus",
                [
                    "CARRY4",
                    "LUT2",
                    "LUT3",
                    "LUT4",
                    "LUT5",
                    "LUT6",
                    "SRL16E",
                    "MUXF7",
                    "MUXF8",
                    "MUXF9",
                ],
                ["DSP48E2"],
                ["FDRE"],
            ),
            _compute_percentages(
                "diamond",
                "lattice-ecp5",
                [
                    "LUT4",
                    "CCU2C",
                ],
                [
                    "MULT9X9D",
                    "MULT18X18D",
                    "MULT18X18C",
                    "ALU54A",
                    "ALU54B",
                ],
                [
                    "TRELLIS_FF",
                    "FD1S3AX",
                    "OFS1P3DX",
                    "DPR16X4C",
                    "IFS1P3DX",
                    "OFS1P3JX",
                    "IFS1P3JX",
                ],
            ),
            _compute_percentages(
                "yosys",
                "lattice-ecp5",
                [
                    "LUT4",
                    "CCU2C",
                ],
                [
                    "MULT9X9D",
                    "MULT18X18D",
                    "MULT18X18C",
                    "ALU54A",
                    "ALU54B",
                ],
                [
                    "TRELLIS_FF",
                    "FD1S3AX",
                    "OFS1P3DX",
                    "DPR16X4C",
                    "IFS1P3DX",
                    "OFS1P3JX",
                    "IFS1P3JX",
                ],
            ),
        ]
    ).to_csv(output_csv)


def _generate_solver_results_table(
    completeness_data_filepath: Union[str, Path],
    out_csv_filepath: Union[str, Path],
):
    df = pd.read_csv(completeness_data_filepath)
    df = df[
        (df["tool"] == "lakeroad")
        & (df["lakeroad_synthesis_timeout"] == False)
        & (
            (df["lakeroad_synthesis_failure"] == True)
            | (df["lakeroad_synthesis_success"] == True)
        )
    ]

    out = pd.DataFrame()
    out["counts"] = df["solver"].value_counts()
    out["fraction"] = out["counts"] / out["counts"].sum()

    Path(out_csv_filepath).parent.mkdir(parents=True, exist_ok=True)
    out.to_csv(out_csv_filepath)


def _plot_timing(
    completeness_data_filepath: Union[str, Path],
    architecture: str,
    plot_output_filepath: Union[str, Path],
    plot_csv_filepath: Union[str, Path],
    title: str,
    num_bins: int = 100,
    alpha: float = 0.5,
    timeout: int = None,
    xlim_timeout_padding: int = 5,
):
    df = pd.read_csv(completeness_data_filepath)
    df = df[
        (df["tool"] == "lakeroad")
        & (df["architecture"] == architecture)
        & (
            (df["lakeroad_synthesis_success"] == True)
            | (df["lakeroad_synthesis_failure"] == True)
        )
        & (df["lakeroad_synthesis_timeout"] == False)
    ]
    assert len(df) > 0, "No data to plot"

    fig, ax = plt.subplots()
    fig.set_figheight(2)
    fig.set_figwidth(6)
    plt.subplots_adjust(bottom=0.22)
    ax.set_title(title)
    if timeout:
        ax.set_xlim(0, timeout + xlim_timeout_padding)
        ax.axvline(x=timeout, color="red", linestyle="--")
    ax.set_ylabel("# completed")
    ax.hist(df["time_s"], alpha=alpha, bins=num_bins)
    ax.set_xlabel("time (s)")

    df.to_csv(plot_csv_filepath)
    fig.savefig(plot_output_filepath)


def _timing_cdf_xilinx(
    csv_filepath: Union[str, Path],
    plot_output_filepath: Union[str, Path],
    timing_csv_filepath: Union[str, Path],
):
    df = pandas.read_csv(csv_filepath).fillna(0)
    # df = df[~df["identifier"].str.match(".*3_stage.*", case=False)]
    lakeroad_df = df[df["tool"] == "lakeroad"]

    xilinx_df = df[df["tool"] == "vivado"]
    # raise(Exception(print(xilinx_df)))
    yosys_df = df[df["tool"] == "yosys"]

    summary_df = lakeroad_df.groupby("tool")["time_s"].agg(["median", "std"])
    summary_df = summary_df.append(
        xilinx_df.groupby("tool")["time_s"].agg(["median", "std"])
    )
    summary_df = summary_df.append(
        yosys_df.groupby("tool")["time_s"].agg(["median", "std"])
    )

    # raise(Exception(print(summary_df)))
    lakeroad_df = lakeroad_df[["time_s"]]
    xilinx_df = xilinx_df[["time_s"]]
    yosys_df = yosys_df[["time_s"]]
    # raise(Exception(print(lakeroad_df)))
    # percentile plot of timing
    gs = GridSpec(1, 1, width_ratios=[1])
    fig = plt.figure(figsize=(10, 5))
    ax = plt.subplot(gs[0])
    ax = lakeroad_df.plot.hist(
        bins=100,
        cumulative=True,
        density=True,
        histtype="step",
        ax=ax,
        xlabel="Time (s)",
        ylabel="Cumulative Density",
        title="Xilinx Timing",
    )
    ax = xilinx_df.plot.hist(
        bins=100,
        cumulative=True,
        density=True,
        histtype="step",
        ax=ax,
        xlabel="Time (s)",
        ylabel="Cumulative Density",
        title="Xilinx Timing",
    )
    ax = yosys_df.plot.hist(
        bins=100,
        cumulative=True,
        density=True,
        histtype="step",
        ax=ax,
        xlabel="Time (s)",
        ylabel="Cumulative Density",
        title="Xilinx Timing",
    )
    plot_output_filepath = Path(plot_output_filepath)
    plot_output_filepath.parent.mkdir(parents=True, exist_ok=True)
    ax.get_figure().savefig(plot_output_filepath)
    timing_csv_filepath = Path(timing_csv_filepath)
    timing_csv_filepath.parent.mkdir(parents=True, exist_ok=True)
    summary_df.to_csv(timing_csv_filepath)


def _timing_cdf_lattice(
    csv_filepath: Union[str, Path],
    plot_output_filepath: Union[str, Path],
    timing_csv_filepath: Union[str, Path],
):
    df = pandas.read_csv(csv_filepath).fillna(0)
    df = df[~df["identifier"].str.match(".*3_stage.*", case=False)]
    lakeroad_df = df[df["tool"] == "lakeroad"]
    lattice_df = df[df["tool"] == "diamond"]
    yosys_df = df[df["tool"] == "yosys"]

    summary_df = lakeroad_df.groupby("tool")["time_s"].agg(["median", "std"])
    summary_df = summary_df.append(
        lattice_df.groupby("tool")["time_s"].agg(["median", "std"])
    )
    summary_df = summary_df.append(
        yosys_df.groupby("tool")["time_s"].agg(["median", "std"])
    )

    # raise(Exception(print(summary_df)))
    lakeroad_df = lakeroad_df[["time_s"]]
    lattice_df = lattice_df[["time_s"]]
    yosys_df = yosys_df[["time_s"]]

    # percentile plot of timing
    gs = GridSpec(1, 1, width_ratios=[1])
    fig = plt.figure(figsize=(10, 5))
    ax = plt.subplot(gs[0])
    ax = lakeroad_df.plot.hist(
        bins=100,
        cumulative=True,
        density=True,
        histtype="step",
        ax=ax,
        xlabel="Time (s)",
        ylabel="Cumulative Density",
        title="Lattice Timing",
    )
    ax = lattice_df.plot.hist(
        bins=100,
        cumulative=True,
        density=True,
        histtype="step",
        ax=ax,
        xlabel="Time (s)",
        ylabel="Cumulative Density",
        title="Lattice Timing",
    )
    ax = yosys_df.plot.hist(
        bins=100,
        cumulative=True,
        density=True,
        histtype="step",
        ax=ax,
        xlabel="Time (s)",
        ylabel="Cumulative Density",
        title="Lattice Timing",
    )
    # check if filepath exists

    ax.get_figure().savefig(plot_output_filepath)
    timing_csv_filepath = Path(timing_csv_filepath)
    timing_csv_filepath.parent.mkdir(parents=True, exist_ok=True)
    summary_df.to_csv(timing_csv_filepath)


def _combined_visualized(
    csv_xilinx_filepath: Union[str, Path],
    csv_lattice_filepath: Union[str, Path],
    csv_intel_filepath: Union[str, Path],
    csv_xilinx_7_series_filepath: Union[str, Path],
    plot_output_filepath: Union[str, Path],
):
    # combined graph of xilinx and lattice results
    df2 = pandas.read_csv(csv_lattice_filepath).fillna(0)
    df2["backend"] = "Lattice"
    df1 = pandas.read_csv(csv_xilinx_filepath).fillna(0)
    df1["backend"] = "Xilinx"
    df_intel = pandas.read_csv(csv_intel_filepath).fillna(0)
    df_intel["backend"] = "Intel"
    df_xilinx_7_series = pandas.read_csv(csv_xilinx_7_series_filepath).fillna(0)
    df_xilinx_7_series["backend"] = "Xilinx 7-Series"
    merged_df = pandas.concat([df1, df2, df_intel, df_xilinx_7_series])
    merged_df.groupby("backend")
    # raise(Exception(print(merged_df)))
    # group the dataframe by xilinx or Yosys
    # merged_df = merged_df.groupby(merged_df.index // 3)
    # plot the merged df
    fig, (ax1, ax2, ax3, ax4) = plt.subplots(1, 4, figsize=(6, 4))
    df1.plot.bar(
        x="tool",
        y=[
            "percentage_successful",
            "percentage_unsuccessful",
            "percentage_lr_unsat",
            "percentage_lr_timeout",
        ],
        stacked=True,
        rot=0,
        ax=ax1,
        legend=None,
        color=["#21de24", "#f71919", "#852EA6", "#000000"],
        # hatch=['', '', '///', '']
    )
    ax1.set_title("Xilinx UltraScale+")
    ax1.set_ylabel("Percentage (%)")
    # Plot Lattice data on the second subplot
    df2.plot.bar(
        x="tool",
        y=[
            "percentage_successful",
            "percentage_unsuccessful",
            "percentage_lr_unsat",
            "percentage_lr_timeout",
        ],
        stacked=True,
        rot=0,
        ax=ax2,
        legend=None,
        color=["#21de24", "#f71919", "#852EA6", "#000000"],
        # hatch=['', '', '///', '']
    )
    ax2.set_title("Lattice ECP5")
    ax2.set_yticks([])

    # Plot Intel data on the third subplot
    df_intel.plot.bar(
        x="tool",
        y=[
            "percentage_successful",
            "percentage_unsuccessful",
            "percentage_lr_unsat",
            "percentage_lr_timeout",
        ],
        stacked=True,
        rot=0,
        ax=ax3,
        color=["#21de24", "#f71919", "#852EA6", "#000000"],
        # hatch=['', '', '///', '']
    )
    ax3.set_title("Intel Cyclone 10 LP")
    ax3.set_yticks([])

    # Plot Xilinx 7-Series data on the third subplot
    df_intel.plot.bar(
        x="tool",
        y=[
            "percentage_successful",
            "percentage_unsuccessful",
            "percentage_lr_unsat",
            "percentage_lr_timeout",
        ],
        stacked=True,
        rot=0,
        ax=ax4,
        color=["#21de24", "#f71919", "#852EA6", "#000000"],
        # hatch=['', '', '///', '']
    )
    ax4.set_title("Xilinx 7-Series")
    ax4.set_yticks([])
    ax4.legend(
        loc="upper right",
        labels=["succeeded", "failed", "unsat", "timeout"],
        fontsize=8,
    )

    # ax2.legend(loc="upper right", labels=["succeeded", "failed", "timeout"], fontsize=7)
    # plt.ylabel("Percentage (%)")
    ax1.set_yticks([0, 20, 40, 60, 80, 100])
    ax1.set_yticklabels(["{:.0f}%".format(x) for x in ax1.get_yticks()])
    # ax2.set_yticklabels(["{:.0f}%".format(x) for x in ax2.get_yticks()])
    plt.tight_layout()
    # Rotate x-axis labels
    for ax in fig.axes:
        plt.sca(ax)
        plt.xticks(rotation=25)

    plot_output_filepath = Path(plot_output_filepath)
    plot_output_filepath.parent.mkdir(parents=True, exist_ok=True)
    plt.savefig(plot_output_filepath, dpi=400)


def _visualize_succeeded_vs_failed_lattice(
    csv_filepath: Union[str, Path],
    plot_output_filepath: Union[str, Path],
    cleaned_data_filepath: Union[str, Path],
    plot_csv_filepath: Union[str, Path],
):
    # Note, we fill NaNs with 0.
    df = pandas.read_csv(csv_filepath).fillna(0)

    # Filter to Lattice rows.
    df = df[df["architecture"] == "lattice-ecp5"]

    # Resources we care about: things that do computation
    # (DSPs,LUTs)/wire manipulation (muxes)/state (registers).
    COMPUTATION_PRIMITIVES = [
        "MULT9X9D",
        "MULT18X18D",
        "MULT18X18C",
        "ALU54A",
        "ALU54B",
        "LUT4",
        "CCU2C",
        # I'm not sure we can really classify these as computation
        # primitives...otherwise everything is classified as a failure for Yosys
        # and Diamond!
        # "TRELLIS_FF",
        # "FD1S3AX",
        # "OFS1P3DX",
        # "DPR16X4C",
        # "IFS1P3DX",
        # "OFS1P3JX",
        # "IFS1P3JX",
    ]

    # Column which checks whether the experiment uses one DSP and no other
    # computational units.
    #
    # For lattice, we define "one DSP" as at most one multiplier and at most one
    # ALU.
    #
    # The first clause says that, if we're using Lakeroad, then Lakeroad must
    # have succeeded. This filters out cases where Lakeroad succeeds, and thus
    # uses no resources at all, and thus passes the rest of the checks.
    df["only_use_one_dsp"] = (
        (~(df["tool"] == "lakeroad") | (df["lakeroad_synthesis_success"] == True))
        & (
            sum(
                map(
                    lambda col: df.get(col, 0),
                    [
                        "MULT9X9D",
                        "MULT18X18D",
                        "MULT18X18C",
                    ],
                )
            )
            <= 1
        )
        & (
            sum(
                map(
                    lambda col: df.get(col, 0),
                    [
                        "ALU54A",
                        "ALU54B",
                    ],
                )
            )
            <= 1
        )
        & (
            sum(
                map(
                    lambda col: df.get(col, 0),
                    list(
                        set(COMPUTATION_PRIMITIVES)
                        - set(
                            [
                                "MULT9X9D",
                                "MULT18X18D",
                                "MULT18X18C",
                                "ALU54A",
                                "ALU54B",
                            ]
                        )
                    ),
                )
            )
            == 0
        )
    )

    # Use boolean indexing to filter the DataFrame
    df = df[~df["identifier"].str.match(".*3_stage.*", case=False)]
    # print timeout and failure columns
    Path(cleaned_data_filepath).parent.mkdir(parents=True, exist_ok=True)
    df.to_csv(cleaned_data_filepath)

    suc_v_unsuc = pandas.DataFrame({"tool": ["lakeroad", "diamond", "yosys"]})
    suc_v_unsuc["num_experiments"] = suc_v_unsuc["tool"].map(
        lambda t: (df["tool"] == t).sum()
    )
    suc_v_unsuc["num_successful"] = suc_v_unsuc["tool"].map(
        lambda t: ((df["tool"] == t) & df["only_use_one_dsp"]).sum()
    )
    # We ignore Lakeroad, because we'll calculate different
    # successful/unsuccessful columns for Lakeroad.
    suc_v_unsuc["num_unsuccessful"] = suc_v_unsuc["tool"].map(
        lambda t: (
            ((df["tool"] == t) & ~df["only_use_one_dsp"]).sum()
            if t != "lakeroad"
            else 0
        )
    )
    # Lakeroad unsuccessful columns.
    suc_v_unsuc["num_lr_unsat"] = suc_v_unsuc["tool"].map(
        lambda t: (
            (
                (df["tool"] == t)
                & ~df["only_use_one_dsp"]
                & df["lakeroad_synthesis_failure"]
            ).sum()
            if t == "lakeroad"
            else 0
        )
    )
    suc_v_unsuc["num_lr_timeout"] = suc_v_unsuc["tool"].map(
        lambda t: (
            (
                (df["tool"] == t)
                & ~df["only_use_one_dsp"]
                & df["lakeroad_synthesis_timeout"]
            ).sum()
            if t == "lakeroad"
            else 0
        )
    )

    def match(t):
        if t == "lakeroad":
            return "Lakeroad"
        elif t == "diamond":
            return "Lattice SOTA"
        elif t == "yosys":
            return "Yosys"
        else:
            raise NotImplementedError()

    suc_v_unsuc["tool"] = suc_v_unsuc["tool"].map(lambda t: match(t))
    # Sanity check.
    assert suc_v_unsuc["num_experiments"].equals(
        suc_v_unsuc["num_successful"]
        + suc_v_unsuc["num_unsuccessful"]
        + suc_v_unsuc["num_lr_unsat"]
        + suc_v_unsuc["num_lr_timeout"]
    )
    suc_v_unsuc["total_experiments"] = (
        suc_v_unsuc["num_successful"]
        + suc_v_unsuc["num_unsuccessful"]
        + suc_v_unsuc["num_lr_unsat"]
        + suc_v_unsuc["num_lr_timeout"]
    )
    # Calculate the percentage of successful, unsuccessful, lakeroad_unsat, and lakeroad_timeout experiments for each tool.
    suc_v_unsuc["percentage_successful"] = (
        suc_v_unsuc["num_successful"] / suc_v_unsuc["total_experiments"]
    ) * 100
    suc_v_unsuc["percentage_unsuccessful"] = (
        suc_v_unsuc["num_unsuccessful"] / suc_v_unsuc["total_experiments"]
    ) * 100
    suc_v_unsuc["percentage_lr_unsat"] = (
        suc_v_unsuc["num_lr_unsat"] / suc_v_unsuc["total_experiments"]
    ) * 100
    suc_v_unsuc["percentage_lr_timeout"] = (
        suc_v_unsuc["num_lr_timeout"] / suc_v_unsuc["total_experiments"]
    ) * 100
    Path(plot_csv_filepath).parent.mkdir(parents=True, exist_ok=True)
    suc_v_unsuc.to_csv(plot_csv_filepath)
    # Plotting the stacked bar chart with percentages on the Y-axis.
    gs = GridSpec(1, 1, width_ratios=[1])
    fig = plt.figure(figsize=(20, 6))
    ax = plt.subplot(gs[0])
    ax = suc_v_unsuc.plot.bar(
        figsize=(5, 2.4),
        x="tool",
        y=[
            "percentage_successful",
            "percentage_unsuccessful",
            "percentage_lr_timeout",
            "percentage_lr_unsat",
        ],
        color=["#1f77b4", "#ff7f0e", "#d62728", "#2ca02c"],
        stacked=True,
        rot=0,
        xlabel="Tool",
        ylabel="Percentage (%)",
    )
    # set timeout bar to be red
    plt.title("Lattice MULT18X18C", pad=10)
    plt.xlabel("Tool", labelpad=10)
    plt.tight_layout()
    plt.ylabel("Percentage (%)")
    ax.set_yticklabels(["{:.0f}%".format(x) for x in ax.get_yticks()])

    # # Save the plot to the specified output filepath.
    plot_output_filepath = Path(plot_output_filepath)
    plot_output_filepath.parent.mkdir(parents=True, exist_ok=True)
    # ax.get_figure().savefig(plot_output_filepath)
    # set legend location
    ax.legend(loc="upper right", labels=["succeeded", "failed", "timeout"], fontsize=7)
    # ax.get_legend().legendHandles[2].set_color("red")
    # raise Exception(print(ax.get_legend().legendHandles[2]))
    ax.get_figure().savefig(plot_output_filepath, dpi=600)


def _visualize_succeeded_vs_failed_xilinx(
    csv_filepath: Union[str, Path],
    plot_output_filepath: Union[str, Path],
    cleaned_data_filepath: Union[str, Path],
    plot_csv_filepath: Union[str, Path],
):
    # Note, we fill NaNs with 0.
    df = pandas.read_csv(csv_filepath).fillna(0)

    # Filter to Xilinx rows.
    df = df[df["architecture"] == "xilinx-ultrascale-plus"]

    # Resources we care about: things that do computation
    # (DSPs,LUTs)/wire manipulation (muxes)/state (registers like
    # SRL16E).
    COMPUTATION_PRIMITIVES = [
        "DSP48E2",
        "CARRY4",
        "LUT2",
        "LUT3",
        "LUT4",
        "LUT5",
        "LUT6",
        "SRL16E",
        "MUXF7",
        "MUXF8",
        "MUXF9",
        "FDRE",
    ]

    # Column which checks whether the experiment uses one DSP and no other
    # computational units.
    df["only_use_one_dsp"] = (df.get("DSP48E2", 0) == 1) & (
        sum(
            map(
                lambda col: df.get(col, 0),
                list(set(COMPUTATION_PRIMITIVES) - set(["DSP48E2"])),
            )
        )
        == 0
    )

    # Remove mul+logic benchmarks
    df = df[~df["identifier"].str.match(".*mulxor.*", case=False)]
    df = df[~df["identifier"].str.match(".*muland.*", case=False)]
    df = df[~df["identifier"].str.match(".*mulor.*", case=False)]

    Path(cleaned_data_filepath).parent.mkdir(parents=True, exist_ok=True)
    df.to_csv(cleaned_data_filepath)

    suc_v_unsuc = pandas.DataFrame({"tool": ["lakeroad", "vivado", "yosys"]})
    suc_v_unsuc["num_experiments"] = suc_v_unsuc["tool"].map(
        lambda t: (df["tool"] == t).sum()
    )
    suc_v_unsuc["num_successful"] = suc_v_unsuc["tool"].map(
        lambda t: ((df["tool"] == t) & df["only_use_one_dsp"]).sum()
    )
    # We ignore Lakeroad, because we'll calculate different
    # successful/unsuccessful columns for Lakeroad.
    suc_v_unsuc["num_unsuccessful"] = suc_v_unsuc["tool"].map(
        lambda t: (
            ((df["tool"] == t) & ~df["only_use_one_dsp"]).sum()
            if t != "lakeroad"
            else 0
        )
    )
    # Lakeroad unsuccessful columns.
    suc_v_unsuc["num_lr_unsat"] = suc_v_unsuc["tool"].map(
        lambda t: (
            (
                (df["tool"] == t)
                & ~df["only_use_one_dsp"]
                & df["lakeroad_synthesis_failure"]
            ).sum()
            if t == "lakeroad"
            else 0
        )
    )
    suc_v_unsuc["num_lr_timeout"] = suc_v_unsuc["tool"].map(
        lambda t: (
            (
                (df["tool"] == t)
                & ~df["only_use_one_dsp"]
                & df["lakeroad_synthesis_timeout"]
            ).sum()
            if t == "lakeroad"
            else 0
        )
    )

    def match(t):
        if t == "lakeroad":
            return "Lakeroad"
        elif t == "vivado":
            return "Xilinx SOTA"
        elif t == "yosys":
            return "Yosys"
        else:
            raise NotImplementedError()

    suc_v_unsuc["tool"] = suc_v_unsuc["tool"].map(lambda t: match(t))

    # raise Exception(
    #     print(suc_v_unsuc["tool"]))

    # Sanity check.
    assert suc_v_unsuc["num_experiments"].equals(
        suc_v_unsuc["num_successful"]
        + suc_v_unsuc["num_unsuccessful"]
        + suc_v_unsuc["num_lr_unsat"]
        + suc_v_unsuc["num_lr_timeout"]
    )
    suc_v_unsuc["total_experiments"] = (
        suc_v_unsuc["num_successful"]
        + suc_v_unsuc["num_unsuccessful"]
        + suc_v_unsuc["num_lr_unsat"]
        + suc_v_unsuc["num_lr_timeout"]
    )

    # Calculate the percentage of successful, unsuccessful, lakeroad_unsat, and lakeroad_timeout experiments for each tool.
    suc_v_unsuc["percentage_successful"] = (
        suc_v_unsuc["num_successful"] / suc_v_unsuc["total_experiments"]
    ) * 100
    suc_v_unsuc["percentage_unsuccessful"] = (
        suc_v_unsuc["num_unsuccessful"] / suc_v_unsuc["total_experiments"]
    ) * 100
    suc_v_unsuc["percentage_lr_unsat"] = (
        suc_v_unsuc["num_lr_unsat"] / suc_v_unsuc["total_experiments"]
    ) * 100
    suc_v_unsuc["percentage_lr_timeout"] = (
        suc_v_unsuc["num_lr_timeout"] / suc_v_unsuc["total_experiments"]
    ) * 100
    Path(plot_csv_filepath).parent.mkdir(parents=True, exist_ok=True)
    suc_v_unsuc.to_csv(plot_csv_filepath)
    # Plotting the stacked bar chart with percentages on the Y-axis.
    gs = GridSpec(1, 1, width_ratios=[1])
    ax = plt.subplot(gs[0])
    ax = suc_v_unsuc.plot.bar(
        figsize=(5, 2.4),
        x="tool",
        y=[
            "percentage_successful",
            "percentage_unsuccessful",
            "percentage_lr_timeout",
            "percentage_lr_unsat",
        ],
        stacked=True,
        rot=0,
        xlabel="Tool",
        ylabel="Percentage (%)",
    )
    plt.title("Xilinx DSP48E2", pad=10)
    plt.xlabel("Tool", labelpad=10)
    plt.tight_layout()
    plt.ylabel("Percentage (%)")
    ax.set_yticklabels(["{:.0f}%".format(x) for x in ax.get_yticks()])
    # # Save the plot to the specified output filepath.
    # plot_output_filepath = Path(plot_output_filepath)
    # plot_output_filepath.parent.mkdir(parents=True, exist_ok=True)
    # ax.get_figure().savefig(plot_output_filepath)
    # set legend location
    ax.legend(
        loc="upper right",
        labels=["succeeded", "failed", "timeout", "unsat"],
        fontsize=7,
    )
    # ax.set_title("Xilinx DSP48E2")
    ax.get_figure().savefig(plot_output_filepath, dpi=600)


def _visualize_succeeded_vs_failed_xilinx_7_series(
    csv_filepath: Union[str, Path],
    plot_output_filepath: Union[str, Path],
    cleaned_data_filepath: Union[str, Path],
    plot_csv_filepath: Union[str, Path],
):
    # Note, we fill NaNs with 0.
    df = pandas.read_csv(csv_filepath).fillna(0)

    # Filter to Xilinx rows.
    df = df[df["architecture"] == "xilinx-7-series"]

    # Resources we care about: things that do computation
    # (DSPs,LUTs)/wire manipulation (muxes)/state (registers like
    # SRL16E).
    COMPUTATION_PRIMITIVES = [
        "DSP48E1",
        # TODO(@vcanumalla): These primitives are for ultrascale,
        # 7series probably has different primitives.
        # "CARRY4",
        # "LUT2",
        # "LUT3",
        # "LUT4",
        # "LUT5",
        # "LUT6",
        # "SRL16E",
        # "MUXF7",
        # "MUXF8",
        # "MUXF9",
        # "FDRE",
    ]

    # Column which checks whether the experiment uses one DSP and no other
    # computational units.
    df["only_use_one_dsp"] = (df.get("DSP48E1", 0) == 1) & (
        sum(
            map(
                lambda col: df.get(col, 0),
                list(set(COMPUTATION_PRIMITIVES) - set(["DSP48E1"])),
            )
        )
        == 0
    )

    Path(cleaned_data_filepath).parent.mkdir(parents=True, exist_ok=True)
    df.to_csv(cleaned_data_filepath)

    suc_v_unsuc = pandas.DataFrame({"tool": ["lakeroad", "vivado", "yosys"]})
    suc_v_unsuc["num_experiments"] = suc_v_unsuc["tool"].map(
        lambda t: (df["tool"] == t).sum()
    )
    suc_v_unsuc["num_successful"] = suc_v_unsuc["tool"].map(
        lambda t: ((df["tool"] == t) & df["only_use_one_dsp"]).sum()
    )
    # We ignore Lakeroad, because we'll calculate different
    # successful/unsuccessful columns for Lakeroad.
    suc_v_unsuc["num_unsuccessful"] = suc_v_unsuc["tool"].map(
        lambda t: (
            ((df["tool"] == t) & ~df["only_use_one_dsp"]).sum()
            if t != "lakeroad"
            else 0
        )
    )
    # Lakeroad unsuccessful columns.
    suc_v_unsuc["num_lr_unsat"] = suc_v_unsuc["tool"].map(
        lambda t: (
            (
                (df["tool"] == t)
                & ~df["only_use_one_dsp"]
                & df["lakeroad_synthesis_failure"]
            ).sum()
            if t == "lakeroad"
            else 0
        )
    )
    suc_v_unsuc["num_lr_timeout"] = suc_v_unsuc["tool"].map(
        lambda t: (
            (
                (df["tool"] == t)
                & ~df["only_use_one_dsp"]
                & df["lakeroad_synthesis_timeout"]
            ).sum()
            if t == "lakeroad"
            else 0
        )
    )

    def match(t):
        if t == "lakeroad":
            return "Lakeroad"
        elif t == "vivado":
            return "Xilinx SOTA"
        elif t == "yosys":
            return "Yosys"
        else:
            raise NotImplementedError()

    suc_v_unsuc["tool"] = suc_v_unsuc["tool"].map(lambda t: match(t))

    # raise Exception(
    #     print(suc_v_unsuc["tool"]))

    # Sanity check.
    assert suc_v_unsuc["num_experiments"].equals(
        suc_v_unsuc["num_successful"]
        + suc_v_unsuc["num_unsuccessful"]
        + suc_v_unsuc["num_lr_unsat"]
        + suc_v_unsuc["num_lr_timeout"]
    ), f"Expected {suc_v_unsuc['num_experiments']} == successful ({suc_v_unsuc['num_successful']}) + unsuccessful ({suc_v_unsuc['num_unsuccessful']}) + LR timeout ({suc_v_unsuc['num_lr_timeout']}) + LR unsat ({suc_v_unsuc['num_lr_unsat']})"
    suc_v_unsuc["total_experiments"] = (
        suc_v_unsuc["num_successful"]
        + suc_v_unsuc["num_unsuccessful"]
        + suc_v_unsuc["num_lr_unsat"]
        + suc_v_unsuc["num_lr_timeout"]
    )

    # Calculate the percentage of successful, unsuccessful, lakeroad_unsat, and lakeroad_timeout experiments for each tool.
    suc_v_unsuc["percentage_successful"] = (
        suc_v_unsuc["num_successful"] / suc_v_unsuc["total_experiments"]
    ) * 100
    suc_v_unsuc["percentage_unsuccessful"] = (
        suc_v_unsuc["num_unsuccessful"] / suc_v_unsuc["total_experiments"]
    ) * 100
    suc_v_unsuc["percentage_lr_unsat"] = (
        suc_v_unsuc["num_lr_unsat"] / suc_v_unsuc["total_experiments"]
    ) * 100
    suc_v_unsuc["percentage_lr_timeout"] = (
        suc_v_unsuc["num_lr_timeout"] / suc_v_unsuc["total_experiments"]
    ) * 100
    Path(plot_csv_filepath).parent.mkdir(parents=True, exist_ok=True)
    suc_v_unsuc.to_csv(plot_csv_filepath)
    # Plotting the stacked bar chart with percentages on the Y-axis.
    gs = GridSpec(1, 1, width_ratios=[1])
    ax = plt.subplot(gs[0])
    ax = suc_v_unsuc.plot.bar(
        figsize=(5, 2.4),
        x="tool",
        y=[
            "percentage_successful",
            "percentage_unsuccessful",
            "percentage_lr_timeout",
            "percentage_lr_unsat",
        ],
        stacked=True,
        rot=0,
        xlabel="Tool",
        ylabel="Percentage (%)",
    )
    plt.title("Xilinx 7-series", pad=10)
    plt.xlabel("Tool", labelpad=10)
    plt.tight_layout()
    plt.ylabel("Percentage (%)")
    ax.set_yticklabels(["{:.0f}%".format(x) for x in ax.get_yticks()])
    # # Save the plot to the specified output filepath.
    # plot_output_filepath = Path(plot_output_filepath)
    # plot_output_filepath.parent.mkdir(parents=True, exist_ok=True)
    # ax.get_figure().savefig(plot_output_filepath)
    # set legend location
    ax.legend(
        loc="upper right",
        labels=["succeeded", "failed", "timeout", "unsat"],
        fontsize=7,
    )
    ax.get_figure().savefig(plot_output_filepath, dpi=600)


def _visualize_succeeded_vs_failed_intel(
    csv_filepath: Union[str, Path],
    plot_output_filepath: Union[str, Path],
    cleaned_data_filepath: Union[str, Path],
    plot_csv_filepath: Union[str, Path],
):
    # Note, we fill NaNs with 0.
    df = pandas.read_csv(csv_filepath).fillna(0)

    # Filter to Intel rows.
    df = df[df["architecture"] == "intel"]
    df = df[df["family"] == "Cyclone 10 LP"]

    # Resources we care about: things that do computation
    # (DSPs,LUTs)/wire manipulation (muxes)/state (registers).
    COMPUTATION_PRIMITIVES = [
        "cyclone10lp_mac_mult",
        "cyclone10lp_mac_out",
        "cyclone10lp_lcell_comb",
        "dffeas",
    ]

    # Column which checks whether the experiment uses one DSP and no other
    # computational units.
    #
    # For Intel, we define this as one mac_mult and 0 or 1 mac_outs.
    # This column is false if there are any `dffeas` (register) primitives, as
    # all tested workloads can use the registers on the `mac` primitives.
    df["only_use_one_dsp"] = (
        # if tool==Lakeroad, check that that Lakeroad succeeded.
        (~(df["tool"] == "lakeroad") | (df["lakeroad_synthesis_success"] == True))
        # Uses exactly one mac mult. Should this be <= 1?
        & (df["cyclone10lp_mac_mult"] == 1)
        # Uses 0 or 1 mac outs.
        & (df["cyclone10lp_mac_out"] <= 1)
        # Whether the number of computation primitives that aren't
        # mac_mult/mac_out is 0.
        & (
            sum(
                # A list of the columns containing the primitive counts for
                # primitives that aren't mac_mult/mac_out.
                map(
                    lambda col: df.get(col, 0),
                    list(
                        set(COMPUTATION_PRIMITIVES)
                        - set(
                            [
                                "cyclone10lp_mac_mult",
                                "cyclone10lp_mac_out",
                            ]
                        )
                    ),
                )
            )
            == 0
        )
    )

    # Filter out 3-stage workloads.
    df = df[~df["identifier"].str.match(".*3_stage.*", case=False)]

    # Write out the cleaned data.
    Path(cleaned_data_filepath).parent.mkdir(parents=True, exist_ok=True)
    df.to_csv(cleaned_data_filepath)

    ## Make a new table which will underlie the output figure.

    # Tool column simply contains the tools we're interested in.
    suc_v_unsuc = pandas.DataFrame({"tool": ["lakeroad", "quartus", "yosys"]})

    # Number of experiments run for each tool.
    suc_v_unsuc["num_experiments"] = suc_v_unsuc["tool"].map(
        lambda t: (df["tool"] == t).sum()
    )

    # Number of "successful" experiments for each tool, i.e. experiments where
    # the tool could map the design to a single DSP (determined by the column we
    # created above).
    suc_v_unsuc["num_successful"] = suc_v_unsuc["tool"].map(
        lambda t: ((df["tool"] == t) & df["only_use_one_dsp"]).sum()
    )

    # Number of "unsuccessful" experiments for each tool. We ignore Lakeroad,
    # because we'll calculate different successful/unsuccessful columns for
    # Lakeroad. (We split Lakeroad's unsuccessful experiments into unsat and
    # timeout.)
    suc_v_unsuc["num_unsuccessful"] = suc_v_unsuc["tool"].map(
        lambda t: (
            ((df["tool"] == t) & ~df["only_use_one_dsp"]).sum()
            if t != "lakeroad"
            else 0
        )
    )

    # Lakeroad unsuccessful columns.
    suc_v_unsuc["num_lr_unsat"] = suc_v_unsuc["tool"].map(
        lambda t: (
            (
                (df["tool"] == t)
                & ~df["only_use_one_dsp"]
                & df["lakeroad_synthesis_failure"]
            ).sum()
            if t == "lakeroad"
            else 0
        )
    )
    suc_v_unsuc["num_lr_timeout"] = suc_v_unsuc["tool"].map(
        lambda t: (
            (
                (df["tool"] == t)
                & ~df["only_use_one_dsp"]
                & df["lakeroad_synthesis_timeout"]
            ).sum()
            if t == "lakeroad"
            else 0
        )
    )

    def match(t):
        if t == "lakeroad":
            return "Lakeroad"
        elif t == "quartus":
            return "Intel SOTA"
        elif t == "yosys":
            return "Yosys"
        else:
            raise NotImplementedError()

    suc_v_unsuc["tool"] = suc_v_unsuc["tool"].map(lambda t: match(t))
    # Sanity check.
    assert suc_v_unsuc["num_experiments"].equals(
        suc_v_unsuc["num_successful"]
        + suc_v_unsuc["num_unsuccessful"]
        + suc_v_unsuc["num_lr_unsat"]
        + suc_v_unsuc["num_lr_timeout"]
    )
    suc_v_unsuc["total_experiments"] = (
        suc_v_unsuc["num_successful"]
        + suc_v_unsuc["num_unsuccessful"]
        + suc_v_unsuc["num_lr_unsat"]
        + suc_v_unsuc["num_lr_timeout"]
    )

    # Calculate the percentage of successful, unsuccessful, lakeroad_unsat, and
    # lakeroad_timeout experiments for each tool.
    suc_v_unsuc["percentage_successful"] = (
        suc_v_unsuc["num_successful"] / suc_v_unsuc["total_experiments"]
    ) * 100
    suc_v_unsuc["percentage_unsuccessful"] = (
        suc_v_unsuc["num_unsuccessful"] / suc_v_unsuc["total_experiments"]
    ) * 100
    suc_v_unsuc["percentage_lr_unsat"] = (
        suc_v_unsuc["num_lr_unsat"] / suc_v_unsuc["total_experiments"]
    ) * 100
    suc_v_unsuc["percentage_lr_timeout"] = (
        suc_v_unsuc["num_lr_timeout"] / suc_v_unsuc["total_experiments"]
    ) * 100

    # Write out plot data to a CSV.
    Path(plot_csv_filepath).parent.mkdir(parents=True, exist_ok=True)
    suc_v_unsuc.to_csv(plot_csv_filepath)

    # Plotting the stacked bar chart with percentages on the Y-axis.
    gs = GridSpec(1, 1, width_ratios=[1])
    fig = plt.figure(figsize=(20, 6))
    ax = plt.subplot(gs[0])
    ax = suc_v_unsuc.plot.bar(
        figsize=(5, 2.4),
        x="tool",
        y=[
            "percentage_successful",
            "percentage_unsuccessful",
            "percentage_lr_timeout",
            "percentage_lr_unsat",
        ],
        color=["#1f77b4", "#ff7f0e", "#d62728", "#2ca02c"],
        stacked=True,
        rot=0,
        xlabel="Tool",
        ylabel="Percentage (%)",
    )

    # set timeout bar to be red
    plt.title("Intel Cyclone 10 LP", pad=10)
    plt.xlabel("Tool", labelpad=10)
    plt.tight_layout()
    plt.ylabel("Percentage (%)")
    ax.set_yticklabels(["{:.0f}%".format(x) for x in ax.get_yticks()])

    # # Save the plot to the specified output filepath.
    plot_output_filepath = Path(plot_output_filepath)
    plot_output_filepath.parent.mkdir(parents=True, exist_ok=True)
    # ax.get_figure().savefig(plot_output_filepath)
    # set legend location
    ax.legend(loc="upper right", labels=["succeeded", "failed"], fontsize=7)
    # ax.get_legend().legendHandles[2].set_color("red")
    # raise Exception(print(ax.get_legend().legendHandles[2]))
    ax.get_figure().savefig(plot_output_filepath, dpi=600)


def _collect_robustness_benchmark_data(
    filepaths: List[Union[str, Path]], output_filepath: Union[str, Path]
):
    """Collect Robustness benchmark results into a file, but do not process them."""
    Path(output_filepath).parent.mkdir(parents=True, exist_ok=True)
    pandas.DataFrame.from_records(
        filter(
            lambda x: x is not None,
            map(lambda f: json.load(open(f)) if os.path.exists(f) else None, filepaths),
        )
    ).to_csv(output_filepath, index=False)


@doit.task_params(
    [
        {
            "name": "skip_verilator",
            "long": "skip_verilator",
            "default": False,
            "type": bool,
        },
    ]
)
def task_robustness_experiments(skip_verilator: bool):
    """Robustness experiments: finding Verilog files that existing tools can't map"""

    manifest = utils.get_manifest()
    output_dir = utils.output_dir()
    lakeroad_evaluation_dir = utils.lakeroad_evaluation_dir()

    entries = yaml.safe_load(stream=open("robustness-manifest.yml", "r"))
    # entries = yaml.safe_load(stream=open("test-robustness.yaml", "r"))

    # This list stores the filepaths to each experiment's output .json file,
    # each of which contains the results of a single experiment.
    collected_data_output_filepaths = []

    for entry in entries:
        backends = entry["backends"]
        if "xilinx-7-series" in backends:
            # TODO(@vcanumalla): Only running 7-series on lakeroad for now.
            base_path = (
                output_dir
                / "robustness_experiments"
                / entry["module_name"]
                / "lakeroad_xilinx_7_series"
            )
            (
                task,
                (json_filepath, lakeroad_output_verilog, _),
            ) = lakeroad.make_lakeroad_task(
                extra_cycles=(
                    manifest["completeness_experiments"]["lakeroad"]["extra_cycles"]
                ),
                out_dirpath=base_path,
                template="dsp",
                out_module_name="lakeroad_output",
                architecture="xilinx-7-series",
                verilog_module_filepath=lakeroad_evaluation_dir / entry["filepath"],
                top_module_name=entry["module_name"],
                clock_name=("clk" if entry["stages"] != 0 else None),
                name=entry["module_name"] + ":lakeroad-xilinx-7-series",
                pipeline_depth=entry["stages"],
                inputs=entry["inputs"],
                verilog_module_out_signal=("out", entry["bitwidth"]),
                timeout=manifest["completeness_experiments"]["lakeroad"][
                    "xilinx-timeout"
                ],
                extra_summary_fields={
                    "identifier": entry["module_name"],
                    "architecture": "xilinx-7-series",
                    "tool": "lakeroad",
                },
            )
            yield task
            collected_data_output_filepaths.append(json_filepath)
            if not skip_verilator:
                yield verilator.make_verilator_task(
                    name=f"{entry['module_name']}:lakeroad-xilinx-7-series:verilator",
                    ignore_missing_test_module_file=True,
                    output_dirpath=base_path / "verilator",
                    test_module_filepath=lakeroad_output_verilog,
                    test_module_name="lakeroad_output",
                    ground_truth_module_filepath=lakeroad_evaluation_dir
                    / entry["filepath"],
                    ground_truth_module_name=entry["module_name"],
                    module_inputs=entry["inputs"],
                    clock_name=("clk" if entry["stages"] != 0 else None),
                    pipeline_depth=entry["stages"],
                    module_outputs=[("out", entry["bitwidth"])],
                    include_dirs=[
                        lakeroad_evaluation_dir
                        / "lakeroad"
                        / "lakeroad-private"
                        / "DSP48E1"
                    ],
                    extra_args=[
                        "-DXIL_XECLIB",
                        "-Wno-UNOPTFLAT",
                        "-Wno-LATCH",
                        "-Wno-WIDTH",
                        "-Wno-STMTDLY",
                        "-Wno-CASEX",
                        "-Wno-TIMESCALEMOD",
                        "-Wno-PINMISSING",
                        "-Wno-COMBDLY",
                        "-Wno-INITIALDLY",
                        "-Wno-CASEINCOMPLETE",
                    ],
                    max_num_tests=manifest["completeness_experiments"]["lakeroad"][
                        "verilator_simulation_iterations"
                    ],
                    alternative_file_dep=json_filepath,
                )[0]

        if "xilinx" in backends:
            # base path for vivado tasks for this entry
            base_path = (
                output_dir / "robustness_experiments" / entry["module_name"] / "vivado"
            )
            # vivado synthesis
            (
                task,
                (json_filepath, _, _, _),
            ) = hardware_compilation.make_xilinx_ultrascale_plus_vivado_synthesis_task_opt(
                input_filepath=lakeroad_evaluation_dir / entry["filepath"],
                output_dirpath=base_path,
                module_name=entry["module_name"],
                # TODO(@gussmith23): Hardcoding clock name and period here.
                # 0.5ns chosen after a few iterations.
                clock_info=("clk", 0.5, (0.0, 0.25)),
                name=f"{entry['module_name']}:vivado",
                # Makes Vivado try harder to put things on DSPs.
                directive="AreaMultThresholdDSP",
                # If our timing constraints are aggressive enough, it won't meet
                # timing. This is okay; don't fail. We want aggressive
                # constraints so we know Vivado is trying as hard as it can.
                fail_if_constraints_not_met=False,
                extra_summary_fields={
                    "identifier": entry["module_name"],
                    "architecture": "xilinx-ultrascale-plus",
                    "tool": "vivado",
                },
                attempts=manifest["completeness_experiments"]["vivado_retries"],
            )
            yield task
            collected_data_output_filepaths.append(json_filepath)

            # Lakeroad Synthesis for xilinx backend
            base_path = (
                output_dir
                / "robustness_experiments"
                / entry["module_name"]
                / "lakeroad_xilinx_ultrascale_plus"
            )

            (
                task,
                (json_filepath, lakeroad_output_verilog, _),
            ) = lakeroad.make_lakeroad_task(
                extra_cycles=(
                    manifest["completeness_experiments"]["lakeroad"]["extra_cycles"]
                ),
                out_dirpath=base_path,
                template="dsp",
                out_module_name="lakeroad_output",
                architecture="xilinx-ultrascale-plus",
                verilog_module_filepath=lakeroad_evaluation_dir / entry["filepath"],
                top_module_name=entry["module_name"],
                clock_name=("clk" if entry["stages"] != 0 else None),
                name=entry["module_name"] + ":lakeroad-xilinx",
                pipeline_depth=entry["stages"],
                inputs=entry["inputs"],
                verilog_module_out_signal=("out", entry["bitwidth"]),
                timeout=manifest["completeness_experiments"]["lakeroad"][
                    "xilinx-timeout"
                ],
                extra_summary_fields={
                    "identifier": entry["module_name"],
                    "architecture": "xilinx-ultrascale-plus",
                    "tool": "lakeroad",
                },
            )
            yield task

            collected_data_output_filepaths.append(json_filepath)

            if not skip_verilator:
                yield verilator.make_verilator_task(
                    name=f"{entry['module_name']}:lakeroad-xilinx:verilator",
                    # TODO(@gussmith23): Ideally, we wouldn't need this flag --
                    # instead, we would know when Lakeroad was going to fail and we
                    # wouldn't create a Verilator task.
                    ignore_missing_test_module_file=True,
                    output_dirpath=base_path / "verilator",
                    test_module_filepath=lakeroad_output_verilog,
                    test_module_name="lakeroad_output",
                    ground_truth_module_filepath=lakeroad_evaluation_dir
                    / entry["filepath"],
                    ground_truth_module_name=entry["module_name"],
                    module_inputs=entry["inputs"],
                    clock_name=("clk" if entry["stages"] != 0 else None),
                    pipeline_depth=entry["stages"],
                    module_outputs=[("out", entry["bitwidth"])],
                    include_dirs=[
                        lakeroad_evaluation_dir
                        / "lakeroad"
                        / "lakeroad-private"
                        / "DSP48E2"
                    ],
                    extra_args=[
                        "-DXIL_XECLIB",
                        "-Wno-UNOPTFLAT",
                        "-Wno-LATCH",
                        "-Wno-WIDTH",
                        "-Wno-STMTDLY",
                        "-Wno-CASEX",
                        "-Wno-TIMESCALEMOD",
                        "-Wno-PINMISSING",
                    ],
                    max_num_tests=manifest["completeness_experiments"]["lakeroad"][
                        "verilator_simulation_iterations"
                    ],
                    alternative_file_dep=json_filepath,
                )[0]

            # yosys synthesis for xilinx backend
            base_path = (
                output_dir
                / "robustness_experiments"
                / entry["module_name"]
                / "yosys_xilinx_ultrascale_plus"
            )
            (
                task,
                (json_filepath, _, _),
            ) = hardware_compilation.make_xilinx_ultrascale_plus_yosys_synthesis_task(
                input_filepath=lakeroad_evaluation_dir / entry["filepath"],
                output_dirpath=base_path,
                module_name=entry["module_name"],
                name=f"{entry['module_name']}:yosys_xilinx_ultrascale_plus",
                extra_summary_fields={
                    "identifier": entry["module_name"],
                    "architecture": "xilinx-ultrascale-plus",
                    "tool": "yosys",
                },
            )
            yield task
            collected_data_output_filepaths.append(json_filepath)

        if "lattice" in backends:
            # diamond-lattice, lakeroad-lattice, yosys-lattice
            base_path = (
                output_dir / "robustness_experiments" / entry["module_name"] / "diamond"
            )
            (
                task,
                (json_filepath,),
            ) = hardware_compilation.make_lattice_ecp5_diamond_synthesis_task(
                input_filepath=lakeroad_evaluation_dir / entry["filepath"],
                output_dirpath=base_path,
                module_name=entry["module_name"],
                name=f"{entry['module_name']}:lattice-ecp5-diamond",
                extra_summary_fields={
                    "identifier": entry["module_name"],
                    "architecture": "lattice-ecp5",
                    "tool": "diamond",
                },
            )
            yield task
            collected_data_output_filepaths.append(json_filepath)

            base_path = (
                output_dir
                / "robustness_experiments"
                / entry["module_name"]
                / "lakeroad_lattice_ecp5"
            )
            (
                task,
                (json_filepath, lakeroad_output_verilog, _),
            ) = lakeroad.make_lakeroad_task(
                extra_cycles=(
                    manifest["completeness_experiments"]["lakeroad"]["extra_cycles"]
                ),
                out_dirpath=base_path,
                template="dsp",
                out_module_name="lakeroad_output",
                architecture="lattice-ecp5",
                verilog_module_filepath=lakeroad_evaluation_dir / entry["filepath"],
                top_module_name=entry["module_name"],
                clock_name=("clk" if entry["stages"] != 0 else None),
                name=entry["module_name"] + ":lattice-ecp5-lakeroad",
                pipeline_depth=entry["stages"],
                inputs=entry["inputs"],
                verilog_module_out_signal=("out", entry["bitwidth"]),
                timeout=manifest["completeness_experiments"]["lakeroad"][
                    "lattice-timeout"
                ],
                extra_summary_fields={
                    "identifier": entry["module_name"],
                    "architecture": "lattice-ecp5",
                    "tool": "lakeroad",
                },
            )
            yield task
            collected_data_output_filepaths.append(json_filepath)

            if not skip_verilator:
                yield verilator.make_verilator_task(
                    name=f"{entry['module_name']}:lattice-ecp5-lakeroad:verilator",
                    # TODO(@gussmith23): Ideally, we wouldn't need this flag --
                    # instead, we would know when Lakeroad was going to fail and we
                    # wouldn't create a Verilator task.
                    ignore_missing_test_module_file=True,
                    output_dirpath=base_path / "verilator",
                    test_module_filepath=lakeroad_output_verilog,
                    test_module_name="lakeroad_output",
                    ground_truth_module_filepath=lakeroad_evaluation_dir
                    / entry["filepath"],
                    ground_truth_module_name=entry["module_name"],
                    module_inputs=entry["inputs"],
                    clock_name=("clk" if entry["stages"] != 0 else None),
                    pipeline_depth=entry["stages"],
                    module_outputs=[("out", entry["bitwidth"])],
                    include_dirs=[
                        lakeroad_evaluation_dir
                        / "lakeroad"
                        / "lakeroad-private"
                        / "lattice_ecp5"
                    ],
                    extra_args=[
                        "-Wno-CASEINCOMPLETE",
                        "-Wno-IMPLICIT",
                        "-Wno-PINMISSING",
                        "-Wno-TIMESCALEMOD",
                        "-Wno-UNOPTFLAT",
                        "-Wno-WIDTH",
                    ],
                    max_num_tests=manifest["completeness_experiments"]["lakeroad"][
                        "verilator_simulation_iterations"
                    ],
                    alternative_file_dep=json_filepath,
                )[0]

            base_path = (
                output_dir
                / "robustness_experiments"
                / entry["module_name"]
                / "yosys_lattice_ecp5"
            )
            (
                task,
                (json_filepath, _, _),
            ) = hardware_compilation.make_lattice_ecp5_yosys_synthesis_task(
                input_filepath=lakeroad_evaluation_dir / entry["filepath"],
                output_dirpath=base_path,
                module_name=entry["module_name"],
                name=f"{entry['module_name']}:lattice-ecp5-yosys",
                extra_summary_fields={
                    "identifier": entry["module_name"],
                    "architecture": "lattice-ecp5",
                    "tool": "yosys",
                },
            )
            yield task
            collected_data_output_filepaths.append(json_filepath)

        if "intel" in backends:
            intel_families = manifest["completeness_experiments"]["intel"]["families"]
            # Easy to update; just make this a loop over the families, if this
            # is needed in the future.
            assert (
                len(intel_families) == 1
            ), "Only one intel family is supported for now"
            family = quartus.IntelFamily.from_str(intel_families[0])
            assert family == quartus.IntelFamily.CYCLONE10LP

            (task, (json_filepath, _)) = quartus.make_quartus_task(
                identifier=entry["module_name"],
                top_module_name=entry["module_name"],
                source_input_filepath=(lakeroad_evaluation_dir / entry["filepath"]),
                base_output_dirpath=(
                    output_dir
                    / "robustness_experiments"
                    / entry["module_name"]
                    / "quartus_intel"
                ),
                iteration=0,
                task_name=f"{entry['module_name']}:quartus_intel",
                working_directory=base_path,
                family=family,
                extra_summary_fields={
                    "identifier": entry["module_name"],
                    "architecture": "intel",
                    "tool": "quartus",
                    "family": str(family),
                },
            )
            yield task
            collected_data_output_filepaths.append(json_filepath)

            (
                task,
                (json_filepath, _, _),
            ) = hardware_compilation.make_intel_yosys_synthesis_task(
                input_filepath=lakeroad_evaluation_dir / entry["filepath"],
                output_dirpath=(
                    output_dir
                    / "robustness_experiments"
                    / entry["module_name"]
                    / "yosys_intel"
                ),
                module_name=entry["module_name"],
                family=family,
                name=f"{entry['module_name']}:yosys_intel",
                extra_summary_fields={
                    "identifier": entry["module_name"],
                    "architecture": "intel",
                    "tool": "yosys",
                    "family": str(family),
                },
            )
            yield task
            collected_data_output_filepaths.append(json_filepath)

            (
                task,
                (json_filepath, verilog_filepath, _),
            ) = lakeroad.make_lakeroad_task(
                extra_cycles=(
                    manifest["completeness_experiments"]["lakeroad"]["extra_cycles"]
                ),
                out_dirpath=(
                    output_dir
                    / "robustness_experiments"
                    / entry["module_name"]
                    / "lakeroad_intel"
                ),
                template="dsp",
                out_module_name="lakeroad_output",
                architecture="intel-cyclone10lp",
                verilog_module_filepath=(lakeroad_evaluation_dir / entry["filepath"]),
                top_module_name=entry["module_name"],
                clock_name=("clk" if entry["stages"] != 0 else None),
                name=entry["module_name"] + ":lakeroad_intel",
                pipeline_depth=entry["stages"],
                inputs=entry["inputs"],
                verilog_module_out_signal=("out", entry["bitwidth"]),
                extra_summary_fields={
                    "identifier": entry["module_name"],
                    "architecture": "intel",
                    "tool": "lakeroad",
                    "family": str(family),
                },
                timeout=manifest["completeness_experiments"]["lakeroad"][
                    "intel-timeout"
                ],
            )
            yield task

            collected_data_output_filepaths.append(json_filepath)

            if not skip_verilator:
                yield verilator.make_verilator_task(
                    name=f"{entry['module_name']}:lakeroad_intel:verilator",
                    # TODO(@gussmith23): Ideally, we wouldn't need this flag --
                    # instead, we would know when Lakeroad was going to fail and we
                    # wouldn't create a Verilator task.
                    ignore_missing_test_module_file=True,
                    output_dirpath=(
                        output_dir
                        / "robustness_experiments"
                        / entry["module_name"]
                        / "lakeroad_intel"
                        / "verilator"
                    ),
                    test_module_filepath=verilog_filepath,
                    test_module_name="lakeroad_output",
                    ground_truth_module_filepath=(
                        lakeroad_evaluation_dir / entry["filepath"]
                    ),
                    ground_truth_module_name=entry["module_name"],
                    module_inputs=entry["inputs"],
                    clock_name=("clk" if entry["stages"] != 0 else None),
                    pipeline_depth=entry["stages"],
                    module_outputs=[("out", entry["bitwidth"])],
                    include_dirs=[
                        lakeroad_evaluation_dir
                        / "lakeroad"
                        / "lakeroad-private"
                        / "intel_cyclone10lp"
                    ],
                    extra_args=[
                        "-Wno-LATCH",
                        "-Wno-INITIALDLY",
                        "-Wno-COMBDLY",
                        "-Wno-TIMESCALEMOD",
                        "-Wno-WIDTH",
                    ],
                    max_num_tests=manifest["completeness_experiments"]["lakeroad"][
                        "verilator_simulation_iterations"
                    ],
                    alternative_file_dep=json_filepath,
                )[0]

    output_csv_path = (
        output_dir / manifest["completeness_experiments"]["output_csv_path"]
    )
    yield {
        "name": "collect_data",
        # To generate the CSV with incomplete data, you can comment out the following line.
        # "file_dep": collected_data_output_filepaths,
        "targets": [output_csv_path],
        "actions": [
            (
                _collect_robustness_benchmark_data,
                [],
                {
                    "filepaths": collected_data_output_filepaths,
                    "output_filepath": output_csv_path,
                },
            )
        ],
    }

    yield {
        "name": "visualize_succeeded_vs_failed_xilinx_7_series",
        "file_dep": [output_csv_path],
        "actions": [
            (
                _visualize_succeeded_vs_failed_xilinx_7_series,
                [],
                {
                    "csv_filepath": output_csv_path,
                    "plot_output_filepath": (
                        output_dir / "figures" / "succeeded_vs_failed_xilinx_7_series.png"
                    ),
                    "cleaned_data_filepath": output_dir
                    / "robustness_experiments_csv"
                    / "all_results"
                    / "all_xilinx_7_series_results_collected_cleaned.csv",
                    "plot_csv_filepath": (
                        output_dir / "figures" / "succeeded_vs_failed_xilinx_7_series.csv"
                    ),
                },
            )
        ],
        "targets": [
            output_dir / "figures" / "succeeded_vs_failed_xilinx_7_series.png",
            output_dir / "figures" / "succeeded_vs_failed_xilinx_7_series.csv",
        ],
    }

    yield {
        "name": "visualize_succeeded_vs_failed_xilinx",
        "file_dep": [output_csv_path],
        "actions": [
            (
                _visualize_succeeded_vs_failed_xilinx,
                [],
                {
                    "csv_filepath": output_csv_path,
                    "plot_output_filepath": (
                        output_dir / "figures" / "succeeded_vs_failed_xilinx.png"
                    ),
                    "cleaned_data_filepath": output_dir
                    / "robustness_experiments_csv"
                    / "all_results"
                    / "all_xilinx_results_collected_cleaned.csv",
                    "plot_csv_filepath": (
                        output_dir / "figures" / "succeeded_vs_failed_xilinx.csv"
                    ),
                },
            )
        ],
        "targets": [
            output_dir / "figures" / "succeeded_vs_failed_xilinx.png",
            output_dir / "figures" / "succeeded_vs_failed_xilinx.csv",
        ],
    }

    yield {
        "name": "visualize_succeeded_vs_failed_lattice",
        "file_dep": [output_csv_path],
        "actions": [
            (
                _visualize_succeeded_vs_failed_lattice,
                [],
                {
                    "csv_filepath": output_csv_path,
                    "plot_output_filepath": (
                        output_dir / "figures" / "succeeded_vs_failed_lattice.png"
                    ),
                    "cleaned_data_filepath": output_dir
                    / "robustness_experiments_csv"
                    / "all_results"
                    / "all_lattice_results_collected_cleaned.csv",
                    "plot_csv_filepath": (
                        output_dir / "figures" / "succeeded_vs_failed_lattice.csv"
                    ),
                },
            )
        ],
        "targets": [
            output_dir / "figures" / "succeeded_vs_failed_lattice.png",
            output_dir / "figures" / "succeeded_vs_failed_lattice.csv",
        ],
    }
    yield {
        "name": "visualize_succeeded_vs_failed_all",
        "file_dep": [
            output_dir / "figures" / "succeeded_vs_failed_lattice.csv",
            output_dir / "figures" / "succeeded_vs_failed_xilinx.csv",
            output_dir / "figures" / "succeeded_vs_failed_intel.csv",
            output_dir / "figures" / "succeeded_vs_failed_xilinx_7_series.csv",
        ],
        "actions": [
            (
                _combined_visualized,
                [],
                {
                    "csv_lattice_filepath": output_dir
                    / "figures"
                    / "succeeded_vs_failed_lattice.csv",
                    "csv_xilinx_filepath": output_dir
                    / "figures"
                    / "succeeded_vs_failed_xilinx.csv",
                    "csv_intel_filepath": output_dir
                    / "figures"
                    / "succeeded_vs_failed_intel.csv",
                    "csv_xilinx_7_series_filepath": output_dir
                    / "figures"
                    / "succeeded_vs_failed_xilinx_7_series.csv",
                    "plot_output_filepath": (
                        output_dir / "figures" / "succeeded_vs_failed_all.png"
                    ),
                },
            )
        ],
    }

    yield {
        "name": "timing",
        "file_dep": [output_csv_path],
        "actions": [
            (
                _timing_cdf_lattice,
                [],
                {
                    "csv_filepath": output_csv_path,
                    "plot_output_filepath": (
                        output_dir / "figures" / "timing_cdf_lattice.png"
                    ),
                    "timing_csv_filepath": (
                        output_dir / "figures" / "timing_cdf_lattice.csv"
                    ),
                },
            ),
            (
                _timing_cdf_xilinx,
                [],
                {
                    "csv_filepath": output_csv_path,
                    "plot_output_filepath": (
                        output_dir / "figures" / "timing_cdf_xilinx.png"
                    ),
                    "timing_csv_filepath": (
                        output_dir / "figures" / "timing_cdf_xilinx.csv"
                    ),
                },
            ),
        ],
    }

    intel_plot_output_filepath = (
        output_dir / "figures" / "succeeded_vs_failed_intel.png"
    )
    intel_cleaned_data_filepath = (
        output_dir
        / "robustness_experiments_csv"
        / "all_results"
        / "all_intel_results_collected_cleaned.csv"
    )
    intel_plot_csv_filepath = output_dir / "figures" / "succeeded_vs_failed_intel.csv"
    yield {
        "name": "visualize_succeeded_vs_failed_intel",
        "file_dep": [output_csv_path],
        "actions": [
            (
                _visualize_succeeded_vs_failed_intel,
                [],
                {
                    "csv_filepath": output_csv_path,
                    "plot_output_filepath": intel_plot_output_filepath,
                    "cleaned_data_filepath": intel_cleaned_data_filepath,
                    "plot_csv_filepath": intel_plot_csv_filepath,
                },
            )
        ],
        "targets": [
            intel_plot_output_filepath,
            intel_cleaned_data_filepath,
            intel_plot_csv_filepath,
        ],
    }

    xilinx_time_png = output_dir / "figures" / "lakeroad_time_xilinx.png"
    xilinx_time_csv = output_dir / "figures" / "lakeroad_time_xilinx.csv"
    yield {
        "name": "lakeroad_time_xilinx",
        "file_dep": [output_csv_path],
        "actions": [
            (
                _plot_timing,
                [],
                {
                    "completeness_data_filepath": output_csv_path,
                    "architecture": "xilinx-ultrascale-plus",
                    "title": "Lakeroad synthesis time on Xilinx",
                    "plot_output_filepath": xilinx_time_png,
                    "plot_csv_filepath": xilinx_time_csv,
                    "num_bins": manifest["completeness_experiments"][
                        "xilinx-timing-num-bins"
                    ],
                    "timeout": manifest["completeness_experiments"]["lakeroad"][
                        "xilinx-timeout"
                    ],
                },
            )
        ],
        "targets": [xilinx_time_png, xilinx_time_csv],
    }

    lattice_time_png = output_dir / "figures" / "lakeroad_time_lattice.png"
    lattice_time_csv = output_dir / "figures" / "lakeroad_time_lattice.csv"
    yield {
        "name": "lakeroad_time_lattice",
        "file_dep": [output_csv_path],
        "actions": [
            (
                _plot_timing,
                [],
                {
                    "completeness_data_filepath": output_csv_path,
                    "architecture": "lattice-ecp5",
                    "title": "Lakeroad synthesis time on Lattice",
                    "plot_output_filepath": lattice_time_png,
                    "plot_csv_filepath": lattice_time_csv,
                    "num_bins": manifest["completeness_experiments"][
                        "lattice-timing-num-bins"
                    ],
                    "timeout": manifest["completeness_experiments"]["lakeroad"][
                        "lattice-timeout"
                    ],
                },
            )
        ],
    }

    intel_time_png = output_dir / "figures" / "lakeroad_time_intel.png"
    intel_time_csv = output_dir / "figures" / "lakeroad_time_intel.csv"
    yield {
        "name": "lakeroad_time_intel",
        "file_dep": [output_csv_path],
        "actions": [
            (
                _plot_timing,
                [],
                {
                    "completeness_data_filepath": output_csv_path,
                    "architecture": "intel",
                    "title": "Lakeroad synthesis time on Intel",
                    "plot_output_filepath": intel_time_png,
                    "plot_csv_filepath": intel_time_csv,
                    "num_bins": manifest["completeness_experiments"][
                        "intel-timing-num-bins"
                    ],
                    "timeout": manifest["completeness_experiments"]["lakeroad"][
                        "intel-timeout"
                    ],
                },
            )
        ],
    }

    solver_results_csv = output_dir / "figures" / "solver_results.csv"
    yield {
        "name": "solver_results",
        "file_dep": [output_csv_path],
        "actions": [
            (
                _generate_solver_results_table,
                [],
                {
                    "completeness_data_filepath": output_csv_path,
                    "out_csv_filepath": solver_results_csv,
                },
            )
        ],
    }

    resource_percentages_csv = output_dir / "figures" / "resource_percentages.csv"
    yield {
        "name": "resource_percentages",
        "file_dep": [output_csv_path],
        "actions": [
            (
                _resource_percentages,
                [],
                {
                    "input_csv": output_csv_path,
                    "output_csv": resource_percentages_csv,
                },
            )
        ],
    }

    timing_table_csv = output_dir / "figures" / "timing_table.csv"
    yield {
        "name": "timing_table",
        "file_dep": [output_csv_path],
        "actions": [
            (
                _timing_table,
                [],
                {
                    "input_csv": output_csv_path,
                    "output_csv": timing_table_csv,
                },
            )
        ],
    }

    solver_counts_csv = output_dir / "figures" / "solver_counts.csv"
    yield {
        "name": "solver_counts",
        "file_dep": [output_csv_path],
        "actions": [
            (
                _solver_counts,
                [],
                {
                    "input_csv": output_csv_path,
                    "output_csv": solver_counts_csv,
                },
            )
        ],
    }

    lakeroad_is_x_times_better_csv = (
        output_dir / "figures" / "lakeroad_is_x_times_better.csv"
    )
    yield {
        "name": "lakeroad_is_x_times_better",
        "file_dep": [
            output_dir / "figures" / "succeeded_vs_failed_lattice.csv",
            output_dir / "figures" / "succeeded_vs_failed_xilinx.csv",
            output_dir / "figures" / "succeeded_vs_failed_intel.csv",
        ],
        "actions": [
            (
                _lakeroad_is_X_times_better_numbers,
                [],
                {
                    "lattice_succeeded_vs_failed_csv": output_dir
                    / "figures"
                    / "succeeded_vs_failed_lattice.csv",
                    "xilinx_succeeded_vs_failed_csv": output_dir
                    / "figures"
                    / "succeeded_vs_failed_xilinx.csv",
                    "intel_succeeded_vs_failed_csv": output_dir
                    / "figures"
                    / "succeeded_vs_failed_intel.csv",
                    "output_csv": lakeroad_is_x_times_better_csv,
                },
            )
        ],
    }
