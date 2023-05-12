from typing import Optional, Union
import hardware_compilation
import utils
import json
import logging

from pathlib import Path

manifest = {
    "robustness_experiments": [
        {
            "filepath": utils.lakeroad_evaluation_dir()
            / "robustness-testing-verilog-files"
            / "two_stage_mult.v",
            "module_name": "two_stage_mult",
        },
        {
            "filepath": utils.lakeroad_evaluation_dir()
            / "robustness-testing-verilog-files"
            / "three_stage_mult.v",
            "module_name": "three_stage_mult",
        },
    ]
}


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

    if dsp_used != expect_dsp:
        logging.ERROR(message)


"""
0. adding more tools to the high-level testing function
2. finish check_for_dsp --> every compilation task should yield a checking task
3. more verilog

"""


def task_robustness_experiments():
    """Robustness experiments: finding Verilog files that existing tools can't map"""

    for experiment in manifest["robustness_experiments"]:
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
