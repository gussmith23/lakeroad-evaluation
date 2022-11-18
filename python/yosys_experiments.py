import subprocess
from pathlib import Path
import utils
import re


def parse_yosys_log(log_txt: str):

    matches = list(
        re.finditer(
            r"""
   Number of cells:.*$
.*

""",
            log_txt,
            flags=re.DOTALL | re.MULTILINE,
        )
    )
    assert len(matches) == 1
    span = matches[0].span()
    matches = list(
        re.finditer(
            r"^     (?P<name>\w+) +(?P<count>\d+)$",
            log_txt[span[0] : span[1]],
            flags=re.MULTILINE,
        )
    )
    resources = {match["name"]: int(match["count"]) for match in matches}

    return resources


def test_file(
    verilog_filepath,
    verilog_module_name,
    verilog_module_output_signal,
    expected_lakeroad_yosys_resources,
    expected_vanilla_yosys_resources,
):
    vanilla_yosys_resources = parse_yosys_log(
        subprocess.run(
            [
                Path(utils.lakeroad_evaluation_dir()) / "yosys" / "yosys",
                "-p",
                f"""
            read_verilog {verilog_filepath};
            synth_xilinx -family xcup;
            """,
            ],
            stdout=subprocess.PIPE,
            check=True,
            encoding="utf8",
        ).stdout
    )

    lakeroad_yosys_resources = parse_yosys_log(
        subprocess.run(
            [
                Path(utils.lakeroad_evaluation_dir()) / "yosys" / "yosys",
                "-p",
                f"""
            read_verilog {verilog_filepath};
            lakeroad {verilog_module_name} {verilog_module_output_signal} xilinx-ultrascale-plus xilinx-ultrascale-plus-dsp48e2;
            write_verilog;
            stat;
            """,
            ],
            stdout=subprocess.PIPE,
            check=True,
            encoding="utf8",
        ).stdout
    )

    print(lakeroad_yosys_resources)
    print(vanilla_yosys_resources)
    assert lakeroad_yosys_resources == expected_lakeroad_yosys_resources
    assert vanilla_yosys_resources == expected_vanilla_yosys_resources


def task_yosys_lakeroad_pass_tests():
    def _make_test(**kwargs):
        return {
            "name": kwargs["verilog_module_name"],
            "actions": [(test_file, [], kwargs)],
        }

    # Confusingly, some of these tests are hanging in boolector, while others
    # are fast.
    yield _make_test(
       verilog_filepath=utils.lakeroad_evaluation_dir() / "verilog" / "test_mul16.v",
       verilog_module_name="test_mul16",
       verilog_module_output_signal="out",
       expected_lakeroad_yosys_resources={"DSP48E2": 1},
       expected_vanilla_yosys_resources={
           "CARRY4": 2,
           "IBUF": 16,
           "LUT2": 3,
           "LUT3": 3,
           "LUT4": 6,
           "LUT5": 5,
           "LUT6": 38,
           "MUXF7": 12,
           "MUXF8": 3,
           "OBUF": 8,
       },
    )
    yield _make_test(
        verilog_filepath=utils.lakeroad_evaluation_dir()
        / "verilog"
        / "test_add_mul_add16.v",
        verilog_module_name="test_add_mul_add16",
        verilog_module_output_signal="out",
        expected_lakeroad_yosys_resources={"DSP48E2": 1},
        expected_vanilla_yosys_resources={
            "CARRY4": 8,
            "DSP48E2": 1,
            "IBUF": 64,
            "LUT2": 32,
            "OBUF": 16,
        },
    )
    yield _make_test(
        verilog_filepath=utils.lakeroad_evaluation_dir() / "verilog" / "test_sub16.v",
        verilog_module_name="test_sub16",
        verilog_module_output_signal="out",
        expected_lakeroad_yosys_resources={"DSP48E2": 1},
        expected_vanilla_yosys_resources={
            "CARRY4": 4,
            "IBUF": 32,
            "LUT2": 16,
            "OBUF": 16,
        },
    )
    yield _make_test(
        verilog_filepath=utils.lakeroad_evaluation_dir() / "verilog" / "test_mul_add16.v",
        verilog_module_name="test_mul_add16",
        verilog_module_output_signal="out",
        expected_lakeroad_yosys_resources={"DSP48E2": 1},
        expected_vanilla_yosys_resources={
            "CARRY4": 4,
            "IBUF": 32,
            "LUT2": 16,
            "OBUF": 16,
        },
    )
    yield _make_test(
        verilog_filepath=utils.lakeroad_evaluation_dir() / "verilog" / "test_add_mul16.v",
        verilog_module_name="test_add_mul16",
        verilog_module_output_signal="out",
        expected_lakeroad_yosys_resources={"DSP48E2": 1},
        expected_vanilla_yosys_resources={
            "CARRY4": 4,
            "IBUF": 32,
            "LUT2": 16,
            "OBUF": 16,
        },
    )
