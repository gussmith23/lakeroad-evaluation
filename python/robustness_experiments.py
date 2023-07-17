from typing import Optional, Union

import yaml
import hardware_compilation
import lakeroad
import utils
import json
import logging
import verilator
import quartus

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
    dsp_list = ["DSP48E2", "MULT18X18D", "ALU54A", "num_MULT18X18D", "num_MULT9X9D"]

    dsp_used = any(resource_utilization[dsp] for dsp in dsp_list)
    message = f"Expected DSP? {expect_dsp}\n DSP used? {dsp_used}"

    # Verify no LUTs
    resources = resource_utilization.keys()
    luts_used = any(
        resource_utilization[resource] for resource in resources if "LUT" in resource
    )
    if luts_used:
        raise Exception("luts are used")
        logging.ERROR(f"Expected 0 LUTs, got {luts_used}")

    if dsp_used != expect_dsp:
        logging.ERROR(message)

def check_dsp_usage(
    module_name: str,
    tool_name: str,
    resource_utilization_json_filepath: Union[str, Path],
    expect_dsp: Optional[bool] = True,
    expect_fail: Optional[bool] = False,
):
    """Check if the resource utilization uses DSPs"""
    pass  

def task_robustness_experiments():
    """Robustness experiments: finding Verilog files that existing tools can't map"""

    entries = yaml.safe_load(stream=open("robustness-manifest.yml", "r"))
    # each entry process the workloads that go along with it
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
            yield hardware_compilation.make_xilinx_ultrascale_plus_vivado_synthesis_task_opt(
                input_filepath=entry["filepath"],
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
            )
            yield {
                "name": f"{entry['module_name']}:vivado:dsp_check",
                "actions": [
                    (
                        check_dsp_usage,
                        [],
                        {
                            "resource_utilization_json_filepath": (
                                base_path / f"{Path(entry['filepath']).stem}_resource_utilization.json"
                            ),
                            "module_name": entry["module_name"],
                        },
                    )
                ],
                "file_dep": [(base_path / f"{Path(entry['filepath']).stem}_resource_utilization.json")],
            }

            # Lakeroad Synthesis for xilinx backend
            base_path = (
                utils.output_dir()
                / "robustness_experiments"
                / entry["module_name"]
                / "lakeroad_xilinx_ultrascale_plus"
            )

            yield lakeroad.make_lakeroad_task(
                # TODO: correct?
                iteration=0,
                identifier=entry["module_name"],
                collected_data_output_filepath=base_path / "collected_data.json",
                template="dsp",
                out_module_name="output",
                out_filepath=base_path / "output.v",
                architecture="xilinx-ultrascale-plus",
                time_filepath=base_path / "out.time",
                json_filepath=base_path / "out.json",
                verilog_module_filepath=entry["filepath"],
                top_module_name=entry["module_name"],
                clock_name="clk",
                name=entry["module_name"] + ":lakeroad-xilinx",
                initiation_interval=entry["stages"],
                inputs=entry["inputs"],
                verilog_module_out_signal=("out", entry["bitwidth"]),
            )
            yield {
                "name": f"{entry['module_name']}:lakeroad-xilinx:dsp_check",
                "actions": [
                    (
                        check_dsp_usage,
                        [],
                        {
                            "resource_utilization_json_filepath": base_path
                            / "collected_data.json",
                            "module_name": entry["module_name"],
                        },
                    )
                ],
                "file_dep": [base_path / "collected_data.json"],
            }
            # yield verilator.make_verilator_task(
            #     f"{entry['module_name']}:lakeroad:verilator",
            #     obj_dir_dir=base_path / "verilator_obj_dir",
            #     test_module_filepath=base_path / "output.v",
            #     ground_truth_module_filepath=entry["filepath"],
            #     module_inputs=entry["inputs"],
            #     clock_name="clk",
            #     initiation_interval=entry["stages"],
            #     testbench_cc_filepath=base_path / "testbench.cc",
            #     testbench_exe_filepath=base_path / "testbench",
            #     testbench_inputs_filepath=base_path / "testbench_inputs.txt",
            #     testbench_stdout_log_filepath=base_path / "testbench_stdout.log",
            #     testbench_stderr_log_filepath=base_path / "testbench_stderr.log",
            #     makefile_filepath=base_path / "Makefile",
            #     output_signal="out",
            #     include_dirs=[
            #         "/home/acheung8/lakeroad-evaluation/lakeroad-private/DSP48E2"
            #     ],
            #     extra_args=[
            #         "-DXIL_XECLIB",
            #         "-Wno-UNOPTFLAT",
            #         "-Wno-LATCH",
            #         "-Wno-WIDTH",
            #         "-Wno-STMTDLY",
            #         "-Wno-CASEX",
            #         "-Wno-TIMESCALEMOD",
            #         "-Wno-PINMISSING",
            #     ],
            #     max_num_tests=10000,
            # )
            # yosys synthesis for xilinx backend
            base_path = (
                utils.output_dir()
                / "robustness_experiments"
                / entry["module_name"]
                / "yosys_xilinx_ultrascale_plus"
            )
            task = (
                hardware_compilation.make_xilinx_ultrascale_plus_yosys_synthesis_task(
                    input_filepath=entry["filepath"],
                    output_dirpath=base_path,
                    module_name=entry["module_name"],
                )
            )
            task["name"] = f"{entry['module_name']}:yosys_xilinx_ultrascale_plus"
            yield task

            resources_filepath = (
                base_path / f"{entry['module_name']}_resource_utilization.json"
            )
            yield {
                "name": f"{entry['module_name']}:yosys_xilinx:dsp_check",
                "actions": [
                    (
                        check_dsp_usage,
                        [],
                        {
                            "resource_utilization_json_filepath": resources_filepath,
                            "module_name": entry["module_name"],
                        },
                    )
                ],
                "file_dep": [resources_filepath],
            }

        if "lattice" in backends:
            # diamond-lattice, lakeroad-lattice, yosys-lattice
            base_path = (
                utils.output_dir()
                / "robustness_experiments"
                / entry["module_name"]
                / "diamond"
            )
            yield hardware_compilation.make_lattice_ecp5_diamond_synthesis_task(
                input_filepath=entry["filepath"],
                output_dirpath=base_path,
                module_name=entry["module_name"],
                name=f"{entry['module_name']}:diamond"
            )
            # TODO(@vcanumalla): ADD lattice backend dsp check
            yield {
                "name": f"{entry['module_name']}:diamond:dsp_check",
                "actions": [
                    (
                        check_dsp_usage,
                        [],
                        {
                            "resource_utilization_json_filepath": (
                                base_path / f"{Path(entry['filepath']).stem}_resource_utilization.json"
                            ),
                            "module_name": entry["module_name"],
                        },
                    )
                ],
                "file_dep": [(base_path / f"{Path(entry['filepath']).stem}_resource_utilization.json")],
            }

            base_path = (
                utils.output_dir()
                / "robustness_experiments"
                / entry["module_name"]
                / "lakeroad_lattice_ecp5"
            )
            task = lakeroad.make_lakeroad_task(
                iteration=0,
                identifier=entry["module_name"],
                collected_data_output_filepath=base_path / "collected_data.json",
                template="dsp",
                out_module_name="output",
                out_filepath=base_path / "output.v",
                architecture="lattice-ecp5",
                time_filepath=base_path / "out.time",
                json_filepath=base_path / "out.json",
                verilog_module_filepath=entry["filepath"],
                top_module_name=entry["module_name"],
                clock_name="clk",
                name=entry["module_name"] + ":lakeroad-lattice",
                initiation_interval=entry["stages"],
                inputs=entry["inputs"],
                verilog_module_out_signal=("out", entry["bitwidth"]),
            )
            yield task

            yield {
                "name": f"{entry['module_name']}:lakeroad-lattice:dsp_check",
                "actions": [
                    (
                        check_dsp_usage,
                        [],
                        {
                            "resource_utilization_json_filepath": base_path
                            / "collected_data.json",
                            "module_name": entry["module_name"],
                        },
                    )
                ],
                "file_dep": [base_path / "collected_data.json"],
            }

            # TODO(@vcanumalla): ADD dsp check and verilator sim
            base_path = (
                utils.output_dir()
                / "robustness_experiments"
                / entry["module_name"]
                / "yosys_lattice_ecp5"
            )
            # yosys for diamond backend
            yield hardware_compilation.make_lattice_ecp5_yosys_synthesis_task(
                input_filepath=entry["filepath"],
                output_dirpath=(
                    utils.output_dir()
                    / "robustness_experiments"
                    / entry["module_name"]
                    / "yosys_lattice_ecp5"
                ),
                module_name=entry["module_name"],
                name=f"{entry['module_name']}:yosys_lattice_ecp5",
            )
            resources_filepath = (
                base_path / f"{entry['module_name']}_resource_utilization.json"
            )

            yield {
                "name": f"{entry['module_name']}:yosys_lattice_ecp5:dsp_check",
                "actions": [
                    (
                        check_dsp_usage,
                        [],
                        {
                            "resource_utilization_json_filepath": resources_filepath,
                            "module_name": entry["module_name"],
                        },
                    )
                ],
                "file_dep": [resources_filepath],
            }

        if "intel" in backends:
            base_path = (
                utils.output_dir()
                / "robustness_experiments"
                / entry["module_name"]
                / "quartus_intel"
            )
            yield quartus.make_quartus_task(
                identifier = entry["module_name"],
                top_module_name = entry["module_name"],
                source_input_filepath = entry["filepath"],
                summary_output_filepath = base_path / "summary.map.summary",
                json_output_filepath = base_path / "out.json",
                time_output_filepath = base_path / "out.time",
                collected_data_output_filepath = base_path / "collected_data.json",
                iteration = 0,
                task_name = f"{entry['module_name']}:quartus_intel"
            )
            base_path = (
                utils.output_dir()
                / "robustness_experiments"
                / entry["module_name"]
                / "lakeroad_intel"
            )
            # TODO(@vcanumalla): Add rest of quartus (yosys)
            yield lakeroad.make_lakeroad_task(
                iteration=0,
                identifier=entry["module_name"],
                collected_data_output_filepath=base_path / "collected_data.json",
                template="dsp",
                out_module_name="output",
                out_filepath=base_path / "output.v",
                architecture="intel",
                time_filepath=base_path / "out.time",
                json_filepath=base_path / "out.json",
                verilog_module_filepath=entry["filepath"],
                top_module_name=entry["module_name"],
                clock_name="clk",
                name=entry["module_name"] + ":lakeroad-intel",
                initiation_interval=entry["stages"],
                inputs=entry["inputs"],
                verilog_module_out_signal=("out", entry["bitwidth"]),
            )
            yield {
                "name": f"{entry['module_name']}:lakeroad-intel:dsp_check",
                "actions": [
                    (
                        check_dsp_usage,
                        [],
                        {
                            "resource_utilization_json_filepath": base_path
                            / "collected_data.json",
                            "module_name": entry["module_name"],
                        },
                    )
                ],
                "file_dep": [base_path / "collected_data.json"],
            }
            yield quartus.make_intel_yosys_synthesis_task(
                input_filepath=entry["filepath"],
                output_dirpath=(
                    utils.output_dir()
                    / "robustness_experiments"
                    / entry["module_name"]
                    / "yosys_intel"
                ),
                module_name=entry["module_name"],
                name=f"{entry['module_name']}:yosys_intel",

            )




if __name__ == "__main__":
    print(create_manifest())
