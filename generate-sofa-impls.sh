#!/bin/bash
# Generate implementations of various instructions for Xilinx UltraScale+ and
# put them into Calyx.

set -e
set -u

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
BASE_DIR="$SCRIPT_DIR"
VERILOG_FILE=$(mktemp)
IMPLS_DIR="$BASE_DIR/sofa_impls"

mkdir -p "$IMPLS_DIR"

generate_instr () {
  local name="$1"
  local instr="$2"
  racket $SCRIPT_DIR/lakeroad/racket/main.rkt \
    --out-format verilog \
    --architecture sofa \
    --module-name "$name" \
    --instruction "$instr"
}

# Generate instructions.

generate_instr lakeroad_xilinx_ultrascale_plus_and1_2 \
  "(bvand (var a 1) (var b 1))" > "$IMPLS_DIR/lakeroad_xilinx_ultrascale_plus_and1_2.v"
generate_instr lakeroad_xilinx_ultrascale_plus_and8_2 \
  "(bvand (var a 8) (var b 8))" > "$IMPLS_DIR/lakeroad_xilinx_ultrascale_plus_and8_2.v"
generate_instr lakeroad_xilinx_ultrascale_plus_and32_2 \
  "(bvand (var a 32) (var b 32))" > "$IMPLS_DIR/lakeroad_xilinx_ultrascale_plus_and32_2.v"
  
generate_instr lakeroad_xilinx_ultrascale_plus_or1_2 \
  "(bvor (var a 1) (var b 1))" > "$IMPLS_DIR/lakeroad_xilinx_ultrascale_plus_or1_2.v"
  
# generate_instr lakeroad_xilinx_ultrascale_plus_add2_2 \
#   "(bvadd (var a 2) (var b 2))" > "$IMPLS_DIR/lakeroad_xilinx_ultrascale_plus_add2_2.v"
# generate_instr lakeroad_xilinx_ultrascale_plus_add3_2 \
#   "(bvadd (var a 3) (var b 3))" > "$IMPLS_DIR/lakeroad_xilinx_ultrascale_plus_add3_2.v"
# generate_instr lakeroad_xilinx_ultrascale_plus_add4_2 \
#   "(bvadd (var a 4) (var b 4))" > "$IMPLS_DIR/lakeroad_xilinx_ultrascale_plus_add4_2.v"
# generate_instr lakeroad_xilinx_ultrascale_plus_add8_2 \
#   "(bvadd (var a 8) (var b 8))" > "$IMPLS_DIR/lakeroad_xilinx_ultrascale_plus_add8_2.v"
# generate_instr lakeroad_xilinx_ultrascale_plus_add32_2 \
#   "(bvadd (var a 32) (var b 32))" > "$IMPLS_DIR/lakeroad_xilinx_ultrascale_plus_add32_2.v"
  
generate_instr lakeroad_xilinx_ultrascale_plus_not1_2 \
  "(bvnot (var a 1))" > "$IMPLS_DIR/lakeroad_xilinx_ultrascale_plus_not1_2.v"

# generate_instr lakeroad_xilinx_ultrascale_plus_sub5_2 \
#   "(bvsub (var a 5) (var b 5))" > "$IMPLS_DIR/lakeroad_xilinx_ultrascale_plus_sub5_2.v"
# generate_instr lakeroad_xilinx_ultrascale_plus_sub6_2 \
#   "(bvsub (var a 6) (var b 6))" > "$IMPLS_DIR/lakeroad_xilinx_ultrascale_plus_sub6_2.v"
# generate_instr lakeroad_xilinx_ultrascale_plus_sub32_2 \
#   "(bvsub (var a 32) (var b 32))" > "$IMPLS_DIR/lakeroad_xilinx_ultrascale_plus_sub32_2.v"
