import subprocess
from pathlib import Path
import utils


def test_file(
    verilog_filepath,
    verilog_module_name,
    verilog_module_output_signal,
    lakeroad_should_map_to_dsp,
    yosys_should_map_to_dsp,
):
    yosys_out = subprocess.run(
        [
            Path(utils.lakeroad_evaluation_dir()) / "yosys" / "yosys",
            "-q",
            "-p",
            f"""
            read_verilog {verilog_filepath};
            synth_xilinx -family xcup;
            write_verilog;
            """,
        ],
        stdout=subprocess.PIPE,
        check=True,
        encoding="utf8",
    ).stdout

    print(yosys_out)

    assert yosys_should_map_to_dsp == (yosys_out.find("DSP48E2") != -1)

    lakeroad_out = subprocess.run(
        [
            Path(utils.lakeroad_evaluation_dir()) / "yosys" / "yosys",
            "-q",
            "-p",
            f"""
            read_verilog {verilog_filepath};
            lakeroad {verilog_module_name} {verilog_module_output_signal} xilinx-ultrascale-plus xilinx-ultrascale-plus-dsp48e2;
            write_verilog;
            """,
        ],
        stdout=subprocess.PIPE,
        check=True,
        encoding="utf8",
    ).stdout

    assert lakeroad_should_map_to_dsp == (lakeroad_out.find("DSP48E2") != -1)


def task_yosys_lakeroad_pass_tests():
    def _make_test(**kwargs):
        return {
            "name": kwargs["verilog_module_name"],
            "actions": [(test_file, [], kwargs)],
        }

    yield _make_test(
        verilog_filepath=utils.lakeroad_evaluation_dir() / "verilog" / "test_mul16.v",
        verilog_module_name="test_mul16",
        verilog_module_output_signal="out",
        lakeroad_should_map_to_dsp=True,
        yosys_should_map_to_dsp=False,
    )
    #yield _make_test(
    #    verilog_filepath=utils.lakeroad_evaluation_dir() / "verilog" / "test_add_mul_add16.v",
    #    verilog_module_name="test_add_mul_add16",
    #    verilog_module_output_signal="out",
    #    lakeroad_should_map_to_dsp=True,
    #    yosys_should_map_to_dsp=False,
    #)
