import pandas as pd
import utils
import subprocess
import json

def _run_cloc(filepath, file_type:str):
    """Run cloc, return lines of code"""

    p = subprocess.run(["cloc", filepath, '--json'], check=True, capture_output=True)

    results  = json.loads(p.stdout)

    return results[file_type]['code']

def task_architecture_descriptions_line_counts():
    lattice_file = utils.lakeroad_evaluation_dir() / "lakeroad" / "architecture_descriptions" / "lattice_ecp5.yml"
    xilinx_file = utils.lakeroad_evaluation_dir() / "lakeroad" / "architecture_descriptions" / "xilinx_ultrascale_plus.yml"
    intel_file = utils.lakeroad_evaluation_dir() / "lakeroad" / "architecture_descriptions" / "intel.yml"
    sofa_file = utils.lakeroad_evaluation_dir() / "lakeroad" / "architecture_descriptions" / "sofa.yml"

    def _impl(output_csv_filepath):

        lattice_loc = _run_cloc(lattice_file, "YAML")
        xilinx_loc = _run_cloc(xilinx_file, "YAML")
        intel_loc = _run_cloc(intel_file, "YAML")
        sofa_loc = _run_cloc(sofa_file, "YAML")

        output_csv_filepath.parent.mkdir(parents=True, exist_ok=True)
        pd.DataFrame.from_records([
            {"architecture": "lattice-ecp5", "sloc": lattice_loc},
            {"architecture": "xilinx-ultrascale-plus", "sloc": xilinx_loc},
            {"architecture": "intel", "sloc": intel_loc},
            {"architecture": "sofa", "sloc": sofa_loc},
        ]
                ).to_csv(output_csv_filepath, index=False)



    output_csv_filepath = utils.output_dir() / "line_counts" / "architecture_descriptions.csv"
    return {
        'actions': [
            (_impl, [output_csv_filepath])
        ],
        'targets': [output_csv_filepath],
        'file_dep': [lattice_file, xilinx_file, intel_file, sofa_file]
    }

