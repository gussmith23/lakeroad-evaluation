import json
import subprocess
from pathlib import Path
import time
from typing import Union
import pandas as pd

import doit
import utils
from hardware_compilation import parse_yosys_log
import socket


def test_file(
    verilog_filepath,
    verilog_module_name,
    verilog_module_output_signal,
    expected_lakeroad_yosys_resources,
    expected_vanilla_yosys_resources,
    vanilla_synth_command,
    architecture,
    template,
    json_output_filepath: Union[Path, str],
):
    vanilla_yosys_start_time = time.time()
    vanilla_yosys_out = subprocess.run(
        [
            Path(utils.lakeroad_evaluation_dir()) / "yosys" / "yosys",
            "-p",
            f"""
            read_verilog {verilog_filepath};
            {vanilla_synth_command};
            """,
        ],
        stdout=subprocess.PIPE,
        check=True,
        encoding="utf8",
    ).stdout
    vanilla_yosys_end_time = time.time()
    vanilla_yosys_resources = parse_yosys_log(vanilla_yosys_out)

    assert vanilla_yosys_resources == expected_vanilla_yosys_resources

    # TODO(@gussmith23): There is a bug in Rosette, documented here:
    # https://github.com/uwsampl/lakeroad/pull/159
    # This bug prevents us from running very specific synthesis tasks on some
    # systems. Namely, 16 bit multiplication won't synthesize on our Ubuntu
    # machine, but will synthesize on my Mac. As a temporary workaround so that
    # eval will run on our Ubuntu machine, I've run the experiments on my Mac,
    # and I just output the data here.
    #
    # When that bug is fixed (or if we find a workaround), we can remove this.
    #
    # Note that all of these are also tested in Lakeroad's tests.
    if socket.gethostname() == "boba" and (
        (
            architecture == "xilinx-ultrascale-plus"
            and template == "xilinx-ultrascale-plus-dsp48e2"
        )
        or (architecture == "lattice-ecp5" and template == "lattice-ecp5-dsp")
    ):
        # Currently this test doesn't write any data, so just return.
        return

    lakeroad_yosys_start_time = time.time()
    lakeroad_yosys_out = subprocess.run(
        [
            Path(utils.lakeroad_evaluation_dir()) / "yosys" / "yosys",
            "-p",
            f"""
            read_verilog {verilog_filepath};
            lakeroad {verilog_module_name} {verilog_module_output_signal} {architecture} {template};
            write_verilog;
            stat;
            """,
        ],
        stdout=subprocess.PIPE,
        check=True,
        encoding="utf8",
    ).stdout
    lakeroad_yosys_end_time = time.time()
    lakeroad_yosys_resources = parse_yosys_log(lakeroad_yosys_out)

    print(lakeroad_yosys_resources)
    print(vanilla_yosys_resources)
    assert lakeroad_yosys_resources == expected_lakeroad_yosys_resources

    out_data = {
        "lakeroad_yosys_runtime_s": lakeroad_yosys_end_time - lakeroad_yosys_start_time,
        "vanilla_yosys_runtime_s": vanilla_yosys_end_time - vanilla_yosys_start_time,
        "module_name": verilog_module_name,
        "architecture": architecture,
    }

    for k, v in lakeroad_yosys_resources.items():
        out_data[f"lakeroad_yosys_{k}"] = v
    for k, v in vanilla_yosys_resources.items():
        out_data[f"vanilla_yosys_{k}"] = v

    Path(json_output_filepath).parent.mkdir(parents=True, exist_ok=True)
    json.dump(out_data, open(json_output_filepath, "w"))


# TODO(@gussmith23): Build a better Yosys evaluation.
@doit.task_params(
    [
        {
            "name": "gathered_data_filepath",
            "default": str(
                utils.output_dir() / "gathered_data" / "yosys_lakeroad_experiments.csv"
            ),
            "type": str,
        },
    ]
)
def disabled_task_yosys_lakeroad_pass_tests(gathered_data_filepath: str):
    json_filepaths = []

    def _make_test(**kwargs):
        kwargs["json_output_filepath"] = (
            utils.output_dir()
            / "yosys_lakeroad_pass_experiments"
            / (kwargs["architecture"] + "_" + kwargs["verilog_module_name"] + ".json")
        )
        json_filepaths.append(kwargs["json_output_filepath"])
        return {
            "name": kwargs["architecture"] + "_" + kwargs["verilog_module_name"],
            "actions": [(test_file, [], kwargs)],
            "targets": [kwargs["json_output_filepath"]],
        }

    # Confusingly, some of these tests are hanging in boolector, while others
    # are fast.
    yield _make_test(
        verilog_filepath=utils.lakeroad_evaluation_dir() / "verilog" / "test_mul16.v",
        verilog_module_name="test_mul16",
        verilog_module_output_signal="out",
        vanilla_synth_command="synth_xilinx -family xcup",
        architecture="xilinx-ultrascale-plus",
        template="xilinx-ultrascale-plus-dsp48e2",
        expected_lakeroad_yosys_resources={"DSP48E2": 1},
        expected_vanilla_yosys_resources={
            "DSP48E2": 1,
            "IBUF": 32,
            "OBUF": 16,
        },
    )
    yield _make_test(
        verilog_filepath=utils.lakeroad_evaluation_dir()
        / "verilog"
        / "test_add_mul_add16.v",
        verilog_module_name="test_add_mul_add16",
        verilog_module_output_signal="out",
        vanilla_synth_command="synth_xilinx -family xcup",
        architecture="xilinx-ultrascale-plus",
        template="xilinx-ultrascale-plus-dsp48e2",
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
        vanilla_synth_command="synth_xilinx -family xcup",
        architecture="xilinx-ultrascale-plus",
        template="xilinx-ultrascale-plus-dsp48e2",
        expected_lakeroad_yosys_resources={"DSP48E2": 1},
        expected_vanilla_yosys_resources={
            "CARRY4": 4,
            "IBUF": 32,
            "LUT2": 16,
            "OBUF": 16,
        },
    )
    yield _make_test(
        verilog_filepath=utils.lakeroad_evaluation_dir()
        / "verilog"
        / "test_mul_add16.v",
        verilog_module_name="test_mul_add16",
        verilog_module_output_signal="out",
        vanilla_synth_command="synth_xilinx -family xcup",
        architecture="xilinx-ultrascale-plus",
        template="xilinx-ultrascale-plus-dsp48e2",
        expected_lakeroad_yosys_resources={"DSP48E2": 1},
        expected_vanilla_yosys_resources={
            "CARRY4": 4,
            "DSP48E2": 1,
            "IBUF": 48,
            "LUT2": 16,
            "OBUF": 16,
        },
    )
    yield _make_test(
        verilog_filepath=utils.lakeroad_evaluation_dir()
        / "verilog"
        / "test_add_mul16.v",
        verilog_module_name="test_add_mul16",
        verilog_module_output_signal="out",
        vanilla_synth_command="synth_xilinx -family xcup",
        architecture="xilinx-ultrascale-plus",
        template="xilinx-ultrascale-plus-dsp48e2",
        expected_lakeroad_yosys_resources={"DSP48E2": 1},
        expected_vanilla_yosys_resources={
            "CARRY4": 4,
            "DSP48E2": 1,
            "IBUF": 48,
            "LUT2": 16,
            "OBUF": 16,
        },
    )

    yield _make_test(
        verilog_filepath=utils.lakeroad_evaluation_dir()
        / "verilog"
        / "test_add_squared16.v",
        verilog_module_name="test_add_squared16",
        verilog_module_output_signal="out",
        vanilla_synth_command="synth_xilinx -family xcup",
        architecture="xilinx-ultrascale-plus",
        template="xilinx-ultrascale-plus-dsp48e2",
        expected_lakeroad_yosys_resources={"DSP48E2": 1},
        expected_vanilla_yosys_resources={
            "CARRY4": 4,
            "DSP48E2": 1,
            "IBUF": 32,
            "LUT2": 16,
            "OBUF": 16,
        },
    )

    yield _make_test(
        verilog_filepath=utils.lakeroad_evaluation_dir()
        / "verilog"
        / "test_sub_squared16.v",
        verilog_module_name="test_sub_squared16",
        verilog_module_output_signal="out",
        vanilla_synth_command="synth_xilinx -family xcup",
        architecture="xilinx-ultrascale-plus",
        template="xilinx-ultrascale-plus-dsp48e2",
        expected_lakeroad_yosys_resources={"DSP48E2": 1},
        expected_vanilla_yosys_resources={
            "CARRY4": 4,
            "DSP48E2": 1,
            "IBUF": 32,
            "LUT2": 16,
            "OBUF": 16,
        },
    )

    yield _make_test(
        verilog_filepath=utils.lakeroad_evaluation_dir()
        / "verilog"
        / "test_sub_squared_sub16.v",
        verilog_module_name="test_sub_squared_sub16",
        verilog_module_output_signal="out",
        vanilla_synth_command="synth_xilinx -family xcup",
        architecture="xilinx-ultrascale-plus",
        template="xilinx-ultrascale-plus-dsp48e2",
        expected_lakeroad_yosys_resources={"DSP48E2": 1},
        expected_vanilla_yosys_resources={
            "CARRY4": 8,
            "DSP48E2": 1,
            "IBUF": 48,
            "LUT2": 32,
            "OBUF": 16,
        },
    )

    yield _make_test(
        verilog_filepath=utils.lakeroad_evaluation_dir()
        / "verilog"
        / "test_add_squared_add16.v",
        verilog_module_name="test_add_squared_add16",
        verilog_module_output_signal="out",
        vanilla_synth_command="synth_xilinx -family xcup",
        architecture="xilinx-ultrascale-plus",
        template="xilinx-ultrascale-plus-dsp48e2",
        expected_lakeroad_yosys_resources={"DSP48E2": 1},
        expected_vanilla_yosys_resources={
            "CARRY4": 8,
            "DSP48E2": 1,
            "IBUF": 48,
            "LUT2": 32,
            "OBUF": 16,
        },
    )

    yield _make_test(
        verilog_filepath=utils.lakeroad_evaluation_dir()
        / "verilog"
        / "test_add_squared_sub16.v",
        verilog_module_name="test_add_squared_sub16",
        verilog_module_output_signal="out",
        vanilla_synth_command="synth_xilinx -family xcup",
        architecture="xilinx-ultrascale-plus",
        template="xilinx-ultrascale-plus-dsp48e2",
        expected_lakeroad_yosys_resources={"DSP48E2": 1},
        expected_vanilla_yosys_resources={
            "CARRY4": 8,
            "DSP48E2": 1,
            "IBUF": 48,
            "LUT2": 32,
            "OBUF": 16,
        },
    )

    yield _make_test(
        verilog_filepath=utils.lakeroad_evaluation_dir()
        / "verilog"
        / "test_sub_squared_add16.v",
        verilog_module_name="test_sub_squared_add16",
        verilog_module_output_signal="out",
        vanilla_synth_command="synth_xilinx -family xcup",
        architecture="xilinx-ultrascale-plus",
        template="xilinx-ultrascale-plus-dsp48e2",
        expected_lakeroad_yosys_resources={"DSP48E2": 1},
        expected_vanilla_yosys_resources={
            "CARRY4": 8,
            "DSP48E2": 1,
            "IBUF": 48,
            "LUT2": 32,
            "OBUF": 16,
        },
    )

    yield _make_test(
        verilog_filepath=utils.lakeroad_evaluation_dir()
        / "verilog"
        / "test_add_mul_xor16.v",
        verilog_module_name="test_add_mul_xor16",
        verilog_module_output_signal="out",
        vanilla_synth_command="synth_xilinx -family xcup",
        architecture="xilinx-ultrascale-plus",
        template="xilinx-ultrascale-plus-dsp48e2",
        expected_lakeroad_yosys_resources={"DSP48E2": 1},
        expected_vanilla_yosys_resources={
            "CARRY4": 4,
            "DSP48E2": 1,
            "IBUF": 64,
            "LUT2": 32,
            "OBUF": 16,
        },
    )

    yield _make_test(
        verilog_filepath=utils.lakeroad_evaluation_dir()
        / "verilog"
        / "test_add_mul_xnor16.v",
        verilog_module_name="test_add_mul_xnor16",
        verilog_module_output_signal="out",
        vanilla_synth_command="synth_xilinx -family xcup",
        architecture="xilinx-ultrascale-plus",
        template="xilinx-ultrascale-plus-dsp48e2",
        expected_lakeroad_yosys_resources={"DSP48E2": 1},
        expected_vanilla_yosys_resources={
            "CARRY4": 4,
            "DSP48E2": 1,
            "IBUF": 64,
            "LUT2": 32,
            "OBUF": 16,
        },
    )

    yield _make_test(
        verilog_filepath=utils.lakeroad_evaluation_dir()
        / "verilog"
        / "test_mul_sub16.v",
        verilog_module_name="test_mul_sub16",
        verilog_module_output_signal="out",
        vanilla_synth_command="synth_xilinx -family xcup",
        architecture="xilinx-ultrascale-plus",
        template="xilinx-ultrascale-plus-dsp48e2",
        expected_lakeroad_yosys_resources={"DSP48E2": 1},
        expected_vanilla_yosys_resources={
            "CARRY4": 4,
            "DSP48E2": 1,
            "IBUF": 48,
            "LUT2": 16,
            "OBUF": 16,
        },
    )

    # TODO could add more of these...

    yield _make_test(
        verilog_filepath=utils.lakeroad_evaluation_dir() / "verilog" / "test_mul16.v",
        verilog_module_name="test_mul16",
        verilog_module_output_signal="out",
        vanilla_synth_command="synth_ecp5",
        architecture="lattice-ecp5",
        template="lattice-ecp5-dsp",
        # TODO: we use an extra ALU when it's not needed.
        expected_lakeroad_yosys_resources={"ALU24B": 1, "MULT18X18D": 1},
        expected_vanilla_yosys_resources={"MULT18X18D": 1},
    )

    yield _make_test(
        verilog_filepath=utils.lakeroad_evaluation_dir()
        / "verilog"
        / "test_mul_add16.v",
        verilog_module_name="test_mul_add16",
        verilog_module_output_signal="out",
        vanilla_synth_command="synth_ecp5",
        architecture="lattice-ecp5",
        template="lattice-ecp5-dsp",
        expected_lakeroad_yosys_resources={"ALU24B": 1, "MULT18X18D": 1},
        expected_vanilla_yosys_resources={"CCU2C": 8, "MULT18X18D": 1},
    )

    yield _make_test(
        verilog_filepath=utils.lakeroad_evaluation_dir()
        / "verilog"
        / "test_mul_sub16.v",
        verilog_module_name="test_mul_sub16",
        verilog_module_output_signal="out",
        vanilla_synth_command="synth_ecp5",
        architecture="lattice-ecp5",
        template="lattice-ecp5-dsp",
        expected_lakeroad_yosys_resources={"ALU24B": 1, "MULT18X18D": 1},
        expected_vanilla_yosys_resources={"CCU2C": 8, "MULT18X18D": 1},
    )

    def _gather_data():
        Path(gathered_data_filepath).parent.mkdir(parents=True, exist_ok=True)
        rows = [json.load(open(filepath)) for filepath in json_filepaths]
        pd.DataFrame(rows).to_csv(gathered_data_filepath, index=False)

    yield {
        "name": "gather_data",
        "actions": [(_gather_data, [])],
        "file_dep": json_filepaths,
        "targets": [gathered_data_filepath],
    }
