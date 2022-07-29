#!/bin/bash
# Top level evaluation script.
#
# Environment variables:
# - SKIP_LAKEROAD_TESTS: Lakeroad tests are run by default. Skips Lakeroad tests when set.
# - EVAL_OUTPUT_DIR: Should be set to the location where evaluation data should be output.

# Fail if any of these commands fail!
set -e
# Fail if env var unset.
set -u 
# Verbose/debug.
set -x

# Run Lakeroad tests, unless we explicitly skip them.
if [ ! -v SKIP_LAKEROAD_TESTS ]; then

  pushd lakeroad
  # Note: ALWAYS use source! This lets us fail if any commands in these scripts fail.
  source run-tests.sh
  popd

fi

# Use Lakeroad to generate implementations of instructions.
./generate-instrs.sh

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
# Run Calyx core tests on UltraScale. We exclude two tests which fail only because of textual differences in core.sv.
runt -d -x '(big-const.futil)|(memory-with-external-attribute.futil)' -i core calyx-xilinx-ultrascale-plus/
calyx-xilinx-ultrascale-plus/bin/fud e calyx-xilinx-ultrascale-plus/examples/tutorial/language-tutorial-iterate.futil \
  -s verilog.data calyx-xilinx-ultrascale-plus/examples/tutorial/data.json \
  --to dat --through verilog -v
# Run Calyx core tests on Lattice. We exclude two tests which fail only because of textual differences in core.sv.
runt -d -x '(big-const.futil)|(memory-with-external-attribute.futil)' -i core calyx-lattice-ecp5/
calyx-lattice-ecp5/bin/fud e calyx-lattice-ecp5/examples/tutorial/language-tutorial-iterate.futil \
  -s verilog.data calyx-lattice-ecp5/examples/tutorial/data.json \
  --to dat --through verilog -v

# Run Calyx tests with Xilinx generated instruction impls.
. calyx-xilinx-ultrascale-plus/bin/activate # Note: use . instead of source.
runt -d -x '(relay)|(mrxl)|(ntt)|(dahlia)|(NTT)|(\[frontend\] dahlia)|(\[core\] backend)' calyx-xilinx-ultrascale-plus/
deactivate

# Run Calyx tests with Lattice generated instruction impls.
. calyx-lattice-ecp5/bin/activate # Note: use . instead of source.
runt -d -x '(relay)|(mrxl)|(ntt)|(dahlia)|(NTT)|(\[frontend\] dahlia)|(\[core\] backend)' calyx-lattice-ecp5/
deactivate

# Generate Yosys
pushd instructions
source run.sh
popd

# Run Vivado eval (maybe)
if [ -v RUN_VIVADO_EVAL ]; then
  source run-vivado.sh
fi