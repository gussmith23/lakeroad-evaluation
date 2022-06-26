#!/bin/bash
# Generate implementations of various instructions for Xilinx UltraScale+ and
# put them into Calyx.

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
VERILOG_FILE=$(mktemp)

# Generate instructions.
$SCRIPT_DIR/lakeroad/racket/main.rkt \
  --out-format verilog \
  --architecture xilinx-ultrascale-plus \
  --module-name lakeroad_xilinx_ultrascale_plus_and8 \
  --instruction "(bvand (var a 8) (var b 8))" \
  --module-name lakeroad_xilinx_ultrascale_plus_add8 \
  --instruction "(bvadd (var a 8) (var b 8))" \
  --module-name lakeroad_xilinx_ultrascale_plus_not1 \
  --instruction "(bvnot (var a 1))" \
  > $VERILOG_FILE

# Insert them into the file. Note that this doesn't delete any existing code, so
# you might have to clean up old code.
sed -i.orig '/^\/\/ BEGIN GENERATED LAKEROAD CODE$/r '<(cat $VERILOG_FILE) "$SCRIPT_DIR/calyx-xilinx-ultrascale-plus/primitives/core.sv"