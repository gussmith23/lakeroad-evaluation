"""Functions and DoIt tasks for generating paper figures."""
from pathlib import Path
from typing import Union
import doit
import pandas as pd
import utils


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
    ]
)
def task_make_sofa_figure(
    gathered_data_filepath: Union[str, Path],
    csv_filepath: Union[str, Path],
    tex_filepath: Union[str, Path],
):
    gathered_data_filepath = Path(gathered_data_filepath)
    csv_filepath = Path(csv_filepath)
    tex_filepath = Path(tex_filepath)

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

        table.to_csv(csv_filepath, )
        table.style.format(precision=1).hide(axis="index").to_latex(tex_filepath)

    return {"actions": [(_impl,)], "file_dep": [gathered_data_filepath]}
