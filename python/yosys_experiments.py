import subprocess
from pathlib import Path
import utils
from hardware_compilation import parse_yosys_log


def test_file(
    verilog_filepath,
    verilog_module_name,
    verilog_module_output_signal,
    expected_lakeroad_yosys_resources,
    expected_vanilla_yosys_resources,
    vanilla_synth_command,
    architecture,
    template,
):
    vanilla_yosys_resources = parse_yosys_log(
        subprocess.run(
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
    )

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
    if (
        architecture == "xilinx-ultrascale-plus"
        and template == "xilinx-ultrascale-plus-dsp48e2"
    ) or (architecture == "lattice-ecp5" and template == "lattice-ecp5-dsp"):
        # Currently this test doesn't write any data, so just return.
        return

    lakeroad_yosys_resources = parse_yosys_log(
        subprocess.run(
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
    )

    print(lakeroad_yosys_resources)
    print(vanilla_yosys_resources)
    assert lakeroad_yosys_resources == expected_lakeroad_yosys_resources


def task_yosys_lakeroad_pass_tests():
    def _make_test(**kwargs):
        return {
            "name": kwargs["architecture"] + "_" + kwargs["verilog_module_name"],
            "actions": [(test_file, [], kwargs)],
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
