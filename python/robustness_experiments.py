import hardware_compilation
import utils

manifest = {
    'robustness_experiments': [
        {'filepath': utils.lakeroad_evaluation_dir() / "robustness-testing-verilog-files" / "two_stage_mult.v",
         'module_name': 'two_stage_mult',},
        {'filepath': utils.lakeroad_evaluation_dir() / "robustness-testing-verilog-files" / "three_stage_mult.v",
         'module_name': 'three_stage_mult',},

        ]
    }

def check_for_dsp(resource_utilization_json_filepath, expect_dsp=True):
    assert num_dsps > 0

"""
1. adding resource_utilization_to_json (hardware_compilation.py)
2. finish check_for_dsp --> every compilation task should yield a checking task
3. more verilog

"""


def task_robustness_experiments():
    """Robustness experiments: finding Verilog files that existing tools can't map"""

    for experiment in manifest['robustness_experiments']:
        base_path = utils.output_dir() / "robustness_experiments" / experiment["module_name"]
        yield {
            'name': experiment["module_name"],
            'actions': [
                (hardware_compilation.xilinx_ultrascale_plus_vivado_synthesis, [],
                {
        'instr_src_file': experiment['filepath'],
        'synth_opt_place_route_output_filepath': base_path / "test_output.v",
        'module_name': experiment["module_name"],
        'time_filepath': base_path / "test_output.time",
        'tcl_script_filepath': base_path / "test_output.tcl",
        'log_path': base_path / "test_output.log",
        'json_filepath': base_path / "test_output.json",
        'resource_utilization_json_filepath': base_path / "test_resources.json",
                })
            ],
        }
