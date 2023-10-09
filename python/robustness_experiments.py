from typing import Optional, Union

import doit
import yaml
import hardware_compilation
import lakeroad
import utils
import json
from typing import List
import pandas
import logging
import verilator
import quartus
import os
from pathlib import Path
import matplotlib.pyplot as plt
from matplotlib.gridspec import GridSpec
import numpy as np
import re


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
    plot_output_filepath: Union[str, Path],
):
    # combined graph of xilinx and lattice results
    df2 = pandas.read_csv(csv_lattice_filepath).fillna(0)
    df2["backend"] = "Lattice"
    df1 = pandas.read_csv(csv_xilinx_filepath).fillna(0)
    df1["backend"] = "Xilinx"
    merged_df = pandas.concat([df1, df2])
    merged_df.groupby("backend")
    # raise(Exception(print(merged_df)))
    # group the dataframe by xilinx or Yosys
    # merged_df = merged_df.groupby(merged_df.index // 3)
    # plot the merged df
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(6, 5))
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
        color=["#28CA2C", "#FF0000", "#852EA6", "#000000"],
        # hatch=['', '', '///', '']
    )
    ax1.set_title("Xilinx Ultrascale+")
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
        color=["#28CA2C", "#FF0000", "#852EA6", "#000000"],
        # hatch=['', '', '///', '']
    )
    ax2.set_title("Lattice ECP5")
    ax2.set_yticks([])
    ax2.legend(
        loc="upper right",
        labels=["succeeded", "failed", "unsat", "timeout"],
        fontsize=8,
    )
    # ax2.legend(loc="upper right", labels=["succeeded", "failed", "timeout"], fontsize=7)
    # plt.ylabel("Percentage (%)")
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

    # Make sure we're aware of all columns that may exist. This is so we're sure
    # that we're not forgetting to take some columns into account.
    assert set(df.columns).issubset(
        set(
            COMPUTATION_PRIMITIVES
            + [
                # Columns we added.
                "time_s",
                "identifier",
                "architecture",
                "tool",
                "returncode",
                "lakeroad_synthesis_success",
                "lakeroad_synthesis_timeout",
                "lakeroad_synthesis_failure",
                # Resources we don't care about.
                "GSR",
                "IB",
                "OB",
                "PUR",
                "VHI",
                "VLO",
                # Registers...see note above.
                "TRELLIS_FF",
                "FD1S3AX",
                "OFS1P3DX",
                "DPR16X4C",
                "IFS1P3DX",
                "OFS1P3JX",
                "IFS1P3JX",
            ]
        )
    )

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
        lambda t: ((df["tool"] == t) & ~df["only_use_one_dsp"]).sum()
        if t != "lakeroad"
        else 0
    )
    # Lakeroad unsuccessful columns.
    suc_v_unsuc["num_lr_unsat"] = suc_v_unsuc["tool"].map(
        lambda t: (
            (df["tool"] == t)
            & ~df["only_use_one_dsp"]
            & df["lakeroad_synthesis_failure"]
        ).sum()
        if t == "lakeroad"
        else 0
    )
    suc_v_unsuc["num_lr_timeout"] = suc_v_unsuc["tool"].map(
        lambda t: (
            (df["tool"] == t)
            & ~df["only_use_one_dsp"]
            & df["lakeroad_synthesis_timeout"]
        ).sum()
        if t == "lakeroad"
        else 0
    )

    def match(t):
        if t == "lakeroad":
            return "Anaxi"
        elif t == "diamond":
            return "SOTA Lattice"
        elif t == "yosys":
            return "Yosys"
        else:
            return t

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

    # Make sure we're aware of all columns that may exist. This is so we're sure
    # that we're not forgetting to take some columns into account.
    assert set(df.columns).issubset(
        set(
            COMPUTATION_PRIMITIVES
            + [
                # Columns we added
                "time_s",
                "identifier",
                "architecture",
                "tool",
                "returncode",
                "lakeroad_synthesis_success",
                "lakeroad_synthesis_timeout",
                "lakeroad_synthesis_failure",
                # Resources we don't care about: things the tools insert that
                # don't do computation.
                "GND",
                "VCC",
                "BUFG",
                "IBUF",
                "OBUF",
            ]
        )
    )

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
        lambda t: ((df["tool"] == t) & ~df["only_use_one_dsp"]).sum()
        if t != "lakeroad"
        else 0
    )
    # Lakeroad unsuccessful columns.
    suc_v_unsuc["num_lr_unsat"] = suc_v_unsuc["tool"].map(
        lambda t: (
            (df["tool"] == t)
            & ~df["only_use_one_dsp"]
            & df["lakeroad_synthesis_failure"]
        ).sum()
        if t == "lakeroad"
        else 0
    )
    suc_v_unsuc["num_lr_timeout"] = suc_v_unsuc["tool"].map(
        lambda t: (
            (df["tool"] == t)
            & ~df["only_use_one_dsp"]
            & df["lakeroad_synthesis_timeout"]
        ).sum()
        if t == "lakeroad"
        else 0
    )

    # raise Exception(print(df))
    # rename the tools in dataframe
    # suc_v_unsuc["tool"] = suc_v_unsuc["tool"].map(
    #     lambda t: "Anaxi" if t == "lakeroad" else t
    # )
    # suc_v_unsuc["tool"] = suc_v_unsuc["tool"].map(
    #     lambda t: "SOTA Xilinx" if t == "vivado" else t
    # )
    # suc_v_unsuc["tool"] = suc_v_unsuc["tool"].map(
    #     lambda t: "Yosys" if t == "yosys" else t
    # )
    def match(t):
        if t == "lakeroad":
            return "Anaxi"
        elif t == "vivado":
            return "SOTA Xilinx"
        elif t == "yosys":
            return "Yosys"
        else:
            return t

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


def check_dsp_usage(
    module_name: str,
    tool_name: str,
    resource_utilization_json_filepath: Union[str, Path],
    expect_only_dsp: Optional[bool] = True,
    expect_fail: Optional[bool] = False,
):
    # raise Exception("incorrect dsp usage without expecting a failed mapping")
    with open(resource_utilization_json_filepath, "r") as f:
        resource_utilization = json.load(f)
    """Check if the resource utilization uses DSPs"""
    # create error folder if it doesn't exist
    if tool_name == "vivado":
        # check all the dsps for vivado
        resource_list = ["DSP48E2", "LUT2"]
        # if we only expect a dsp, raise exceptions if we see conflicting results in the resource utilization
        if expect_only_dsp:
            # NO DSP USED
            if (
                "DSP48E2" not in resource_utilization
                or resource_utilization["DSP48E2"] > 1
            ):
                if not expect_fail:
                    raise Exception(
                        "incorrect dsp usage without expecting a failed mapping"
                    )
            # OTHER PRIMITIVES USED
            if "LUT2" in resource_utilization:
                if not expect_fail:
                    raise Exception("lut used without expecting a failed mapping")

    if tool_name == "lakeroad-xilinx":
        resource_list = ["DSP48E2", "LUT2"]
        if expect_only_dsp:
            if (
                "DSP48E2" not in resource_utilization
                or resource_utilization["DSP48E2"] > 1
            ):
                if not expect_fail:
                    raise Exception(
                        "incorrect dsp usage without expecting a failed mapping"
                    )
            if "LUT2" in resource_utilization:
                if not expect_fail:
                    raise Exception("lut used without expecting a failed mapping")
    if tool_name == "yosys-xilinx":
        resource_list = ["DSP48E2", "LUT2"]
        if expect_only_dsp:
            if (
                "DSP48E2" not in resource_utilization
                or resource_utilization["DSP48E2"] > 1
            ):
                if not expect_fail:
                    raise Exception(
                        "incorrect dsp usage without expecting a failed mapping"
                    )
            if "LUT2" in resource_utilization:
                if not expect_fail:
                    raise Exception("lut used without expecting a failed mapping")
    if tool_name == "diamond":
        # Skip all of the non-computational primitives
        resource_skip_set = set(
            [
                "FD1S3AX",
                "GSR",
                "IB",
                "OB",
                "OFS1P3DX",
                "PUR",
                "VHI",
                "VLO",
                "DPR16X4C",
                "IFS1P3DX",
            ]
        )
        computational = resource_utilization.keys() - resource_skip_set

        # check to make sure only dsps are in the computational primitives based off what we expect
        if expect_only_dsp:
            if (
                "MULT9X9D" not in resource_utilization
                and "MULT18X18D" not in resource_utilization
            ):
                if not expect_fail:
                    with open(error_folder_path / "diamond.json", "w+") as f:
                        json.dump(resource_utilization, f)
                    raise Exception(
                        "incorrect dsp usage without expecting a failed mapping"
                    )
                    # raise Exception("lut used without expecting a failed mapping")
            if len(computational) != 1:
                if not expect_fail:
                    with open(error_folder_path / "diamond.json", "w+") as f:
                        json.dump(resource_utilization, f)
                    # raise Exception("incorrect dsp usage withot expecting a failed mapping")
                    raise Exception("extra primitives used" + str(computational))
    if tool_name == "lakeroad-lattice":
        if expect_only_dsp:
            if (
                "MULT18X18D" not in resource_utilization
                or resource_utilization["MULT18X18D"] > 1
            ):
                if not expect_fail:
                    with open(error_folder_path / "diamond.json", "w+") as f:
                        json.dump(resource_utilization, f)
                    # raise Exception("incorrect dsp usage without expecting a failed mapping")
            if len(resource_utilization) != 1:
                if not expect_fail:
                    with open(error_folder_path / "diamond.json", "w+") as f:
                        json.dump(resource_utilization, f)
                    # raise Exception("lut used without expecting a failed mapping")
    if tool_name == "yosys-lattice":
        if expect_only_dsp:
            if (
                "MULT18X18D" not in resource_utilization
                or resource_utilization["MULT18X18D"] > 1
            ):
                if not expect_fail:
                    with open(error_folder_path / "diamond.json", "w+") as f:
                        json.dump(resource_utilization, f)
                    # raise Exception("incorrect dsp usage without expecting a failed mapping")
                    # raise Exception("lut used without expecting a failed mapping")
            if len(resource_utilization) != 1:
                if not expect_fail:
                    with open(error_folder_path / "diamond.json", "w+") as f:
                        json.dump(resource_utilization, f)
                    # raise Exception("incorrect dsp usage without expecting a failed mapping")
                    # raise Exception("lut used without expecting a failed mapping")
    if tool_name == "quartus":
        if expect_only_dsp:
            if "dsps" not in resource_utilization or resource_utilization["dsps"] > 1:
                if not expect_fail:
                    with open(error_folder_path / "diamond.json", "w+") as f:
                        json.dump(resource_utilization, f)
                    # raise Exception("incorrect dsp usage without expecting a failed mapping")
                    # raise Exception("lut used without expecting a failed mapping")
            if len(resource_utilization) != 1:
                if not expect_fail:
                    with open(error_folder_path / "diamond.json", "w+") as f:
                        json.dump(resource_utilization, f)
                    # raise Exception("incorrect dsp usage without expecting a failed mapping")
                    # raise Exception("lut used without expecting a failed mapping")
    if tool_name == "lakeroad-intel":
        if expect_only_dsp:
            if (
                "altmult_accum" not in resource_utilization
                or resource_utilization["altmult_accum"] > 1
            ):
                if not expect_fail:
                    with open(error_folder_path / "diamond.json", "w+") as f:
                        json.dump(resource_utilization, f)
                    # raise Exception("incorrect dsp usage without expecting a failed mapping")
                    # raise Exception("lut used without expecting a failed mapping")
            if len(resource_utilization) != 1:
                if not expect_fail:
                    with open(error_folder_path / "diamond.json", "w+") as f:
                        json.dump(resource_utilization, f)
                    # raise Exception("incorrect dsp usage without expecting a failed mapping")
                    # raise Exception("lut used without expecting a failed mapping")


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

    entries = yaml.safe_load(stream=open("robustness-manifest.yml", "r"))
    # entries = yaml.safe_load(stream=open("test-robustness.yaml", "r"))

    # .json file that contains metadata is produced for each entry's synthesis.
    xilinx_collected_data_output_filepaths = []
    lattice_collected_data_output_filepaths = []
    intel_collected_data_output_filepaths = []

    # determines if the compiler fails for the workload we're looking at
    def contains_compiler_fail(entry, tool_name):
        if "expect_fail" in entry:
            if tool_name in entry["expect_fail"]:
                return True
        return False

    # if there is a timeout for lakeroad
    def contains_compiler_timeout(entry):
        if "expect_timeout" in entry:
            return True
        return False

    for entry in entries:
        backends = entry["backends"]
        if "xilinx" in backends:
            # base path for vivado tasks for this entry
            base_path = (
                utils.output_dir()
                / "robustness_experiments"
                / entry["module_name"]
                / "vivado"
            )
            # vivado synthesis
            (
                task,
                (json_filepath, _, _, _),
            ) = hardware_compilation.make_xilinx_ultrascale_plus_vivado_synthesis_task_opt(
                input_filepath=utils.lakeroad_evaluation_dir() / entry["filepath"],
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
            )
            yield task
            xilinx_collected_data_output_filepaths.append(json_filepath)

            # Lakeroad Synthesis for xilinx backend
            base_path = (
                utils.output_dir()
                / "robustness_experiments"
                / entry["module_name"]
                / "lakeroad_xilinx_ultrascale_plus"
            )

            (
                task,
                (json_filepath, lakeroad_output_verilog, _),
            ) = lakeroad.make_lakeroad_task(
                out_dirpath=base_path,
                template="dsp",
                out_module_name="lakeroad_output",
                architecture="xilinx-ultrascale-plus",
                verilog_module_filepath=utils.lakeroad_evaluation_dir()
                / entry["filepath"],
                top_module_name=entry["module_name"],
                clock_name=("clk" if entry["stages"] != 0 else None),
                name=entry["module_name"] + ":lakeroad-xilinx",
                initiation_interval=entry["stages"],
                inputs=entry["inputs"],
                verilog_module_out_signal=("out", entry["bitwidth"]),
                timeout=utils.get_manifest()["completeness_experiments"]["lakeroad"][
                    "timeout"
                ],
                extra_summary_fields={
                    "identifier": entry["module_name"],
                    "architecture": "xilinx-ultrascale-plus",
                    "tool": "lakeroad",
                },
            )
            yield task

            xilinx_collected_data_output_filepaths.append(json_filepath)

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
                    ground_truth_module_filepath=utils.lakeroad_evaluation_dir()
                    / entry["filepath"],
                    ground_truth_module_name=entry["module_name"],
                    module_inputs=entry["inputs"],
                    clock_name=("clk" if entry["stages"] != 0 else None),
                    initiation_interval=entry["stages"],
                    module_outputs=[("out", entry["bitwidth"])],
                    include_dirs=[
                        utils.lakeroad_evaluation_dir() / "lakeroad-private" / "DSP48E2"
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
                    max_num_tests=utils.get_manifest()["completeness_experiments"][
                        "lakeroad"
                    ]["verilator_simulation_iterations"],
                    alternative_file_dep=json_filepath,
                )[0]

            # yosys synthesis for xilinx backend
            base_path = (
                utils.output_dir()
                / "robustness_experiments"
                / entry["module_name"]
                / "yosys_xilinx_ultrascale_plus"
            )
            (
                task,
                (json_filepath, _, _),
            ) = hardware_compilation.make_xilinx_ultrascale_plus_yosys_synthesis_task(
                input_filepath=utils.lakeroad_evaluation_dir() / entry["filepath"],
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
            xilinx_collected_data_output_filepaths.append(json_filepath)

        if "lattice" in backends:
            # diamond-lattice, lakeroad-lattice, yosys-lattice
            base_path = (
                utils.output_dir()
                / "robustness_experiments"
                / entry["module_name"]
                / "diamond"
            )
            (
                task,
                (json_filepath,),
            ) = hardware_compilation.make_lattice_ecp5_diamond_synthesis_task(
                input_filepath=utils.lakeroad_evaluation_dir() / entry["filepath"],
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
            lattice_collected_data_output_filepaths.append(json_filepath)

            base_path = (
                utils.output_dir()
                / "robustness_experiments"
                / entry["module_name"]
                / "lakeroad_lattice_ecp5"
            )
            (
                task,
                (json_filepath, lakeroad_output_verilog, _),
            ) = lakeroad.make_lakeroad_task(
                out_dirpath=base_path,
                template="dsp",
                out_module_name="lakeroad_output",
                architecture="lattice-ecp5",
                verilog_module_filepath=utils.lakeroad_evaluation_dir()
                / entry["filepath"],
                top_module_name=entry["module_name"],
                clock_name=("clk" if entry["stages"] != 0 else None),
                name=entry["module_name"] + ":lattice-ecp5-lakeroad",
                initiation_interval=entry["stages"],
                inputs=entry["inputs"],
                verilog_module_out_signal=("out", entry["bitwidth"]),
                timeout=utils.get_manifest()["completeness_experiments"]["lakeroad"][
                    "timeout"
                ],
                extra_summary_fields={
                    "identifier": entry["module_name"],
                    "architecture": "lattice-ecp5",
                    "tool": "lakeroad",
                },
            )
            yield task
            lattice_collected_data_output_filepaths.append(json_filepath)

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
                    ground_truth_module_filepath=utils.lakeroad_evaluation_dir()
                    / entry["filepath"],
                    ground_truth_module_name=entry["module_name"],
                    module_inputs=entry["inputs"],
                    clock_name=("clk" if entry["stages"] != 0 else None),
                    initiation_interval=entry["stages"],
                    module_outputs=[("out", entry["bitwidth"])],
                    include_dirs=[
                        utils.lakeroad_evaluation_dir()
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
                    max_num_tests=utils.get_manifest()["completeness_experiments"][
                        "lakeroad"
                    ]["verilator_simulation_iterations"],
                    alternative_file_dep=json_filepath,
                )[0]

            base_path = (
                utils.output_dir()
                / "robustness_experiments"
                / entry["module_name"]
                / "yosys_lattice_ecp5"
            )
            (
                task,
                (json_filepath, _, _),
            ) = hardware_compilation.make_lattice_ecp5_yosys_synthesis_task(
                input_filepath=utils.lakeroad_evaluation_dir() / entry["filepath"],
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
            lattice_collected_data_output_filepaths.append(json_filepath)

        if "intel" in backends:
            intel_familes = utils.get_manifest()["completeness_experiments"]["intel"][
                "families"
            ]
            # Easy to update; just make this a loop over the families, if this
            # is needed in the future.
            assert len(intel_familes) == 1, "Only one intel family is supported for now"
            family = quartus.IntelFamily.from_str(intel_familes[0])

            (task, (json_filepath, _)) = quartus.make_quartus_task(
                identifier=entry["module_name"],
                top_module_name=entry["module_name"],
                source_input_filepath=(
                    utils.lakeroad_evaluation_dir() / entry["filepath"]
                ),
                base_output_dirpath=(
                    utils.output_dir()
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
            intel_collected_data_output_filepaths.append(json_filepath)

            (
                task,
                (json_filepath, _, _),
            ) = hardware_compilation.make_intel_yosys_synthesis_task(
                input_filepath=utils.lakeroad_evaluation_dir() / entry["filepath"],
                output_dirpath=(
                    utils.output_dir()
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
            intel_collected_data_output_filepaths.append(json_filepath)

        #     base_path = (
        #         utils.output_dir()
        #         / "robustness_experiments"
        #         / entry["module_name"]
        #         / "lakeroad_intel"
        #     )
        #     # TODO(@vcanumalla): Add rest of quartus (yosys)
        #     yield lakeroad.make_lakeroad_task(
        #         iteration=0,
        #         identifier=entry["module_name"],
        #         collected_data_output_filepath=base_path / "collected_data.json",
        #         template="dsp",
        #         out_module_name="output",
        #         out_filepath=base_path / "output.v",
        #         architecture="intel",
        #         time_filepath=base_path / "out.time",
        #         json_filepath=base_path / "out.json",
        #         verilog_module_filepath=utils.lakeroad_evaluation_dir()/ entry["filepath"],
        #         top_module_name=entry["module_name"],
        #         clock_name=("clk" if entry["stages"] != 0 else None),,
        #         name=entry["module_name"] + ":lakeroad-intel",
        #         initiation_interval=entry["stages"],
        #         inputs=entry["inputs"],
        #         verilog_module_out_signal=("out", entry["bitwidth"]),
        #     )
        #     yield {
        #         "name": f"{entry['module_name']}:lakeroad-intel:dsp_check",
        #         "actions": [
        #             (
        #                 check_dsp_usage,
        #                 [],
        #                 {
        #                     "resource_utilization_json_filepath": base_path
        #                     / "collected_data.json",
        #                     "module_name": entry["module_name"],
        #                     "tool_name": "lakeroad-intel",
        #                 },
        #             )
        #         ],
        #         "file_dep": [base_path / "collected_data.json"],
        #     }
        #     yield quartus.make_intel_yosys_synthesis_task(
        #         input_filepath=utils.lakeroad_evaluation_dir()/ entry["filepath"],
        #         output_dirpath=(
        #             utils.output_dir()
        #             / "robustness_experiments"
        #             / entry["module_name"]
        #             / "yosys_intel"
        #         ),
        #         module_name=entry["module_name"],
        #         name=f"{entry['module_name']}:yosys_intel",

        #     )
        #     yield {
        #         "name": f"{entry['module_name']}:yosys_intel:dsp_check",
        #         "actions": [
        #             (
        #                 check_dsp_usage,
        #                 [],
        #                 {
        #                     "resource_utilization_json_filepath": resources_filepath,
        #                     "module_name": entry["module_name"],
        #                 },
        #             )
        #         ],
        #         "file_dep": [resources_filepath],
        #     }
    base_path = utils.output_dir() / "robustness_experiments_csv"
    xilinx_csv_output = base_path / "all_results" / "all_xilinx_results_collected.csv"
    yield {
        "name": "collect_xilinx_data",
        # To generate the CSV with incomplete data, you can comment out the following line.
        "file_dep": xilinx_collected_data_output_filepaths,
        "targets": [xilinx_csv_output],
        "actions": [
            (
                _collect_robustness_benchmark_data,
                [],
                {
                    "filepaths": xilinx_collected_data_output_filepaths,
                    "output_filepath": xilinx_csv_output,
                },
            )
        ],
    }

    yield {
        "name": "visualize_succeeded_vs_failed_xilinx",
        "file_dep": [xilinx_csv_output],
        "actions": [
            (
                _visualize_succeeded_vs_failed_xilinx,
                [],
                {
                    "csv_filepath": xilinx_csv_output,
                    "plot_output_filepath": (
                        utils.output_dir()
                        / "figures"
                        / "succeeded_vs_failed_xilinx.png"
                    ),
                    "cleaned_data_filepath": utils.output_dir()
                    / "robustness_experiments_csv"
                    / "all_results"
                    / "all_xilinx_results_collected_cleaned.csv",
                    "plot_csv_filepath": (
                        utils.output_dir()
                        / "figures"
                        / "succeeded_vs_failed_xilinx.csv"
                    ),
                },
            )
        ],
        "targets": [
            utils.output_dir() / "figures" / "succeeded_vs_failed_xilinx.png",
            utils.output_dir()
            / "robustness_experiments_csv"
            / "all_results"
            / "all_xilinx_results_collected_cleaned.csv",
        ],
    }

    base_path = utils.output_dir() / "robustness_experiments_csv"
    lattice_csv_output = base_path / "all_results" / "all_lattice_results_collected.csv"

    yield {
        "name": "collect_lattice_data",
        # To generate the CSV with incomplete data, you can comment out the following line.
        "file_dep": lattice_collected_data_output_filepaths,
        "targets": [lattice_csv_output],
        "actions": [
            (
                _collect_robustness_benchmark_data,
                [],
                {
                    "filepaths": lattice_collected_data_output_filepaths,
                    "output_filepath": lattice_csv_output,
                },
            )
        ],
    }

    intel_csv_output = (
        utils.output_dir()
        / "robustness_experiments_csv"
        / "all_results"
        / "all_intel_results_collected.csv"
    )
    yield {
        "name": "collect_intel_data",
        # To generate the CSV with incomplete data, you can comment out the following line.
        "file_dep": intel_collected_data_output_filepaths,
        "targets": [intel_csv_output],
        "actions": [
            (
                _collect_robustness_benchmark_data,
                [],
                {
                    "filepaths": intel_collected_data_output_filepaths,
                    "output_filepath": intel_csv_output,
                },
            )
        ],
    }

    yield {
        "name": "visualize_succeeded_vs_failed_lattice",
        "file_dep": [lattice_csv_output],
        "actions": [
            (
                _visualize_succeeded_vs_failed_lattice,
                [],
                {
                    "csv_filepath": lattice_csv_output,
                    "plot_output_filepath": (
                        utils.output_dir()
                        / "figures"
                        / "succeeded_vs_failed_lattice.png"
                    ),
                    "cleaned_data_filepath": utils.output_dir()
                    / "robustness_experiments_csv"
                    / "all_results"
                    / "all_lattice_results_collected_cleaned.csv",
                    "plot_csv_filepath": (
                        utils.output_dir()
                        / "figures"
                        / "succeeded_vs_failed_lattice.csv"
                    ),
                },
            )
        ],
        "targets": [
            utils.output_dir() / "figures" / "succeeded_vs_failed_lattice.png",
            utils.output_dir()
            / "robustness_experiments_csv"
            / "all_results"
            / "all_lattice_results_collected_cleaned.csv",
        ],
    }
    yield {
        "name": "visualize_succeeded_vs_failed_all",
        "file_dep": [lattice_csv_output, xilinx_csv_output],
        "actions": [
            (
                _combined_visualized,
                [],
                {
                    "csv_lattice_filepath": utils.output_dir()
                    / "figures"
                    / "succeeded_vs_failed_lattice.csv",
                    "csv_xilinx_filepath": utils.output_dir()
                    / "figures"
                    / "succeeded_vs_failed_xilinx.csv",
                    "plot_output_filepath": (
                        utils.output_dir() / "figures" / "succeeded_vs_failed_all.png"
                    ),
                },
            )
        ],
    }

    yield {
        "name": "timing",
        "file_dep": [lattice_csv_output, xilinx_csv_output],
        "actions": [
            (
                _timing_cdf_lattice,
                [],
                {
                    "csv_filepath": lattice_csv_output,
                    "plot_output_filepath": (
                        utils.output_dir() / "figures" / "timing_cdf_lattice.png"
                    ),
                    "timing_csv_filepath": (
                        utils.output_dir() / "figures" / "timing_cdf_lattice.csv"
                    ),
                },
            ),
            (
                _timing_cdf_xilinx,
                [],
                {
                    "csv_filepath": xilinx_csv_output,
                    "plot_output_filepath": (
                        utils.output_dir() / "figures" / "timing_cdf_xilinx.png"
                    ),
                    "timing_csv_filepath": (
                        utils.output_dir() / "figures" / "timing_cdf_xilinx.csv"
                    ),
                },
            ),
        ],
    }
