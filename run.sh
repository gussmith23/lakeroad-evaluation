#!/bin/bash

# Fail if any of these commands fail!
set -e

pushd lakeroad
# Note: ALWAYS use source! This lets us fail if any commands in these scripts fail.
source run-tests.sh
popd

pushd yosys-example
source run.sh
popd

# Run Calyx tests. Note that a lot of the non-core tests won't work due to other
# missing deps.
runt -i core calyx/
# Test compilation with Calyx.
calyx/bin/fud e calyx/examples/tutorial/language-tutorial-iterate.futil \
  -s verilog.data calyx/examples/tutorial/data.json \
  --to dat --through verilog -v
# Now with Xilinx UltraScale+ version...
runt -i core calyx-xilinx-ultrascale-plus/
calyx-xilinx-ultrascale-plus/bin/fud e calyx-xilinx-ultrascale-plus/examples/tutorial/language-tutorial-iterate.futil \
  -s verilog.data calyx-xilinx-ultrascale-plus/examples/tutorial/data.json \
  --to dat --through verilog -v