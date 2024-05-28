from pathlib import Path
# run Yosys passes on generated verilog files
def run_yosys_passes(opname: string):
  # get the lakeroad structural output.
  lr_output = Path(f'out/robustness_experiments/{opname}/lakeroad_xilinx_ultrascale_plus/lakeroad_result.sv')
  # check if file exists, return error if not
  if not lr_output.exists():
    return f'File {lr_output} does not exist.'

  

def output_verilog_file():
  verilog = Path('robustness-testing-verilog-files/two_stage_mult.v')
  print(verilog)
  Path.mkdir('test_dir')

def task_verin():
  """Tasks for the Verin project."""
  return {
    'actions': [(
      output_verilog_file,
      [],
      {}
    )],
  }

## Get a lakeroad sv file, simulate it against the behavioral file.
