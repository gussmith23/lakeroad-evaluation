#!/bin/bash
# Generate implementations of various instructions for Xilinx UltraScale+ and
# put them into Calyx.

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
VERILOG_FILE=$(mktemp)

# Generate instructions.
racket $SCRIPT_DIR/lakeroad/racket/main.rkt \
  --out-format verilog \
  --architecture xilinx-ultrascale-plus \
  \
  --module-name lakeroad_xilinx_ultrascale_plus_and1 \
  --instruction "(bvand (var a 1) (var b 1))" \
  --module-name lakeroad_xilinx_ultrascale_plus_and8 \
  --instruction "(bvand (var a 8) (var b 8))" \
  --module-name lakeroad_xilinx_ultrascale_plus_and32 \
  --instruction "(bvand (var a 32) (var b 32))" \
  \
  --module-name lakeroad_xilinx_ultrascale_plus_or1 \
  --instruction "(bvor (var a 1) (var b 1))" \
  \
  --module-name lakeroad_xilinx_ultrascale_plus_add2 \
  --instruction "(bvadd (var a 2) (var b 2))" \
  --module-name lakeroad_xilinx_ultrascale_plus_add3 \
  --instruction "(bvadd (var a 3) (var b 3))" \
  --module-name lakeroad_xilinx_ultrascale_plus_add4 \
  --instruction "(bvadd (var a 4) (var b 4))" \
  --module-name lakeroad_xilinx_ultrascale_plus_add8 \
  --instruction "(bvadd (var a 8) (var b 8))" \
  --module-name lakeroad_xilinx_ultrascale_plus_add32 \
  --instruction "(bvadd (var a 32) (var b 32))" \
  \
  --module-name lakeroad_xilinx_ultrascale_plus_not1 \
  --instruction "(bvnot (var a 1))" \
  \
  --module-name lakeroad_xilinx_ultrascale_plus_sub5 \
  --instruction "(bvsub (var a 5) (var b 5))" \
  --module-name lakeroad_xilinx_ultrascale_plus_sub6 \
  --instruction "(bvsub (var a 6) (var b 6))" \
  --module-name lakeroad_xilinx_ultrascale_plus_sub32 \
  --instruction "(bvsub (var a 32) (var b 32))" \
  \
  > $VERILOG_FILE

# Insert them into the file. Note that this doesn't delete any existing code, so
# you might have to clean up old code.
sed -i.orig '/^\/\/ BEGIN GENERATED LAKEROAD CODE$/r '<(cat $VERILOG_FILE) "$SCRIPT_DIR/calyx-xilinx-ultrascale-plus/primitives/core.sv"