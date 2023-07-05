from typing import Optional, Union

import yaml
import hardware_compilation
import lakeroad
import utils
import json
import logging
import verilator

from pathlib import Path


def check_for_dsp(
    module_name: str,
    resource_utilization_json_filepath: Union[str, Path],
    expect_dsp: Optional[bool] = True,
):
    """Check if a DSP was used in the design"""
    with open(resource_utilization_json_filepath, "r") as f:
        resource_utilization = json.load(f)

    # TODO : maybe we want a way to distinguish between architectures, but I doubt
    # we'll need to separate them
    dsp_list = ["DSP48E2"]

    dsp_used = any(resource_utilization[dsp] for dsp in dsp_list)
    message = f"Expected DSP? {expect_dsp}\n DSP used? {dsp_used}"

    # Verify no LUTs
    resources = resource_utilization.keys()
    luts_used = any(
        resource_utilization[resource] for resource in resources if "LUT" in resource
    )
    if luts_used:
        error = resource_utilization["bad key"]
        logging.ERROR(f"Expected 0 LUTs, got {luts_used}")

    if dsp_used != expect_dsp:
        logging.ERROR(message)


def task_robustness_experiments():
    """Robustness experiments: finding Verilog files that existing tools can't map"""
    # first, read list from robustness-manifest.yml
    experiments = yaml.safe_load(stream=open("robustness-manifest.yml", "r"))

    for experiment in experiments:
        base_path = (
            utils.output_dir()
            / "robustness_experiments"
            / experiment["module_name"]
            / "vivado"
        )
        yield {
            "name": f"{experiment['module_name']}:vivado",
            "actions": [
                (
                    hardware_compilation.xilinx_ultrascale_plus_vivado_synthesis,
                    [],
                    {
                        "instr_src_file": experiment["filepath"],
                        "synth_opt_place_route_output_filepath": (
                            base_path / "test_output.v"
                        ),
                        "module_name": experiment["module_name"],
                        "time_filepath": base_path / "test_output.time",
                        "tcl_script_filepath": base_path / "test_output.tcl",
                        "log_path": base_path / "test_output.log",
                        "json_filepath": base_path / "test_output.json",
                        "resource_utilization_json_filepath": (
                            base_path / "test_resources.json"
                        ),
                    },
                )
            ],
            "targets": [base_path / "test_output.v", base_path / "test_resources.json"],
        }

        yield {
            "name": f"{experiment['module_name']}:vivado:dsp_check",
            "actions": [
                (
                    check_for_dsp,
                    [],
                    {
                        "resource_utilization_json_filepath": base_path
                        / "test_resources.json",
                        "module_name": experiment["module_name"],
                    },
                )
            ],
            "file_dep": [base_path / "test_resources.json"],
        }

        base_path = (
            utils.output_dir()
            / "robustness_experiments"
            / experiment["module_name"]
            / "lakeroad"
        )

        task = lakeroad.make_lakeroad_task(
            # TODO: correct?
            iteration=0,
            identifier=experiment["module_name"],
            collected_data_output_filepath=base_path / "collected_data.json",
            template="dsp",
            out_module_name="output",
            out_filepath=base_path / "output.v",
            architecture="xilinx-ultrascale-plus",
            time_filepath=base_path / "out.time",
            json_filepath=base_path / "out.json",
            verilog_module_filepath=experiment["filepath"],
            top_module_name=experiment["module_name"],
            clock_name="clk",
            name=experiment["module_name"] + ":lakeroad",
            initiation_interval=experiment["stages"],
            inputs=experiment["inputs"],
            verilog_module_out_signal=("out", experiment["bitwidth"]),
        )

        yield task

        yield {
            "name": f"{experiment['module_name']}:lakeroad:dsp_check",
            "actions": [
                (
                    check_for_dsp,
                    [],
                    {
                        "resource_utilization_json_filepath": base_path
                        / "collected_data.json",
                        "module_name": experiment["module_name"],
                    },
                )
            ],
            "file_dep": [base_path / "collected_data.json"],
        }

        yield verilator.make_verilator_task(
            f"{experiment['module_name']}:lakeroad:verilator",
            obj_dir_dir=base_path / "verilator_obj_dir",
            test_module_filepath=base_path / "output.v",
            ground_truth_module_filepath=experiment["filepath"],
            module_inputs=experiment["inputs"],
            clock_name="clk",
            initiation_interval=experiment["stages"],
            testbench_cc_filepath=base_path / "testbench.cc",
            testbench_exe_filepath=base_path / "testbench",
            testbench_inputs_filepath=base_path / "testbench_inputs.txt",
            testbench_stdout_log_filepath=base_path / "testbench_stdout.log",
            testbench_stderr_log_filepath=base_path / "testbench_stderr.log",
            makefile_filepath=base_path / "Makefile",
            output_signal="out",
            include_dirs=[
                "/home/acheung8/lakeroad-evaluation/lakeroad-private/DSP48E2"
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
            max_num_tests=10000,
        )

        # BELOW IS YOSYS EXPERIMENTS

        base_path = (
            utils.output_dir()
            / "robustness_experiments"
            / experiment["module_name"]
            / "yosys_xilinx_ultrascale_plus"
        )

        task = hardware_compilation.make_xilinx_ultrascale_plus_yosys_synthesis_task(
            input_filepath=experiment["filepath"],
            output_dirpath=base_path,
            module_name=experiment["module_name"],
        )

        task["name"] = f"{experiment['module_name']}:yosys_xilinx_ultrascale_plus"
        yield task

        resources_filepath = base_path / f"{experiment['module_name']}.resources.json"

        yield {
            "name": f"{experiment['module_name']}:yosys:dsp_check",
            "actions": [
                (
                    check_for_dsp,
                    [],
                    {
                        "resource_utilization_json_filepath": resources_filepath,
                        "module_name": experiment["module_name"],
                    },
                )
            ],
            "file_dep": [resources_filepath],
        }


if __name__ == "__main__":
    print(create_manifest())
