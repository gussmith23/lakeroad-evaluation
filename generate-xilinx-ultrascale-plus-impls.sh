#!/bin/bash
# Generate implementations of various instructions for Xilinx UltraScale+ and
# put them into Calyx.

set -e
set -u

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
BASE_DIR="$SCRIPT_DIR"
VERILOG_FILE=$(mktemp)
IMPLS_DIR="$BASE_DIR/xilinx_ultrascale_plus_impls"

mkdir -p "$IMPLS_DIR"

generate_instr () {
  local name="$1"
  local instr="$2"
  racket $SCRIPT_DIR/lakeroad/racket/main.rkt \
    --out-format verilog \
    --architecture xilinx-ultrascale-plus \
    --module-name "$name" \
    --instruction "$instr"
}

# Generate instructions.

for bw in 1 2 4 8 16 32 64 128; do
  generate_instr "lakeroad_xilinx_ultrascale_plus_and${bw}_2" \
    "(bvand (var a ${bw}) (var b ${bw}))" > "$IMPLS_DIR/lakeroad_xilinx_ultrascale_plus_and${bw}_2.v"
  generate_instr "lakeroad_xilinx_ultrascale_plus_or${bw}_2" \
    "(bvor (var a ${bw}) (var b ${bw}))" > "$IMPLS_DIR/lakeroad_xilinx_ultrascale_plus_or${bw}_2.v"
  generate_instr "lakeroad_xilinx_ultrascale_plus_xor${bw}_2" \
    "(bvxor (var a ${bw}) (var b ${bw}))" > "$IMPLS_DIR/lakeroad_xilinx_ultrascale_plus_xor${bw}_2.v"
  generate_instr "lakeroad_xilinx_ultrascale_plus_not${bw}_1" \
    "(bvnot (var a ${bw}))" > "$IMPLS_DIR/lakeroad_xilinx_ultrascale_plus_not${bw}_1.v"
  generate_instr "lakeroad_xilinx_ultrascale_plus_add${bw}_2" \
    "(bvadd (var a ${bw}) (var b ${bw}))" > "$IMPLS_DIR/lakeroad_xilinx_ultrascale_plus_add${bw}_2.v"
  generate_instr "lakeroad_xilinx_ultrascale_plus_sub${bw}_2" \
    "(bvsub (var a ${bw}) (var b ${bw}))" > "$IMPLS_DIR/lakeroad_xilinx_ultrascale_plus_sub${bw}_2.v"
  generate_instr "lakeroad_xilinx_ultrascale_plus_eq${bw}_2" \
    "(bool->bitvector (bveq (var a ${bw}) (var b ${bw})))" > "$IMPLS_DIR/lakeroad_xilinx_ultrascale_plus_eq${bw}_2.v"
  generate_instr "lakeroad_xilinx_ultrascale_plus_neq${bw}_2" \
    "(bool->bitvector (not (bveq (var a ${bw}) (var b ${bw}))))" > "$IMPLS_DIR/lakeroad_xilinx_ultrascale_plus_neq${bw}_2.v"
  generate_instr "lakeroad_xilinx_ultrascale_plus_ugt${bw}_2" \
    "(bool->bitvector (bvugt (var a ${bw}) (var b ${bw})))" > "$IMPLS_DIR/lakeroad_xilinx_ultrascale_plus_ugt${bw}_2.v"
  generate_instr "lakeroad_xilinx_ultrascale_plus_ult${bw}_2" \
    "(bool->bitvector (bvult (var a ${bw}) (var b ${bw})))" > "$IMPLS_DIR/lakeroad_xilinx_ultrascale_plus_ult${bw}_2.v"
  generate_instr "lakeroad_xilinx_ultrascale_plus_uge${bw}_2" \
    "(bool->bitvector (bvuge (var a ${bw}) (var b ${bw})))" > "$IMPLS_DIR/lakeroad_xilinx_ultrascale_plus_uge${bw}_2.v"
  generate_instr "lakeroad_xilinx_ultrascale_plus_ule${bw}_2" \
    "(bool->bitvector (bvule (var a ${bw}) (var b ${bw})))" > "$IMPLS_DIR/lakeroad_xilinx_ultrascale_plus_ule${bw}_2.v"

  generate_instr "lakeroad_xilinx_ultrascale_plus_mux${bw}_3" \
    "(bool->bitvector (circt-comb-mux (var a ${bw}) (var b ${bw}) (var c ${bw})))" > "$IMPLS_DIR/lakeroad_xilinx_ultrascale_plus_mux${bw}_3.v"
done 

generate_instr lakeroad_xilinx_ultrascale_plus_add3_2 \
  "(bvadd (var a 3) (var b 3))" > "$IMPLS_DIR/lakeroad_xilinx_ultrascale_plus_add3_2.v"

generate_instr lakeroad_xilinx_ultrascale_plus_sub5_2 \
  "(bvsub (var a 5) (var b 5))" > "$IMPLS_DIR/lakeroad_xilinx_ultrascale_plus_sub5_2.v"
generate_instr lakeroad_xilinx_ultrascale_plus_sub6_2 \
  "(bvsub (var a 6) (var b 6))" > "$IMPLS_DIR/lakeroad_xilinx_ultrascale_plus_sub6_2.v"

generate_instr lakeroad_xilinx_ultrascale_plus_eq5_2 \
  "(bool->bitvector (bveq (var a 5) (var b 5)))" > "$IMPLS_DIR/lakeroad_xilinx_ultrascale_plus_eq5_2.v"
generate_instr lakeroad_xilinx_ultrascale_plus_eq6_2 \
  "(bool->bitvector (bveq (var a 6) (var b 6)))" > "$IMPLS_DIR/lakeroad_xilinx_ultrascale_plus_eq6_2.v"

generate_instr lakeroad_xilinx_ultrascale_plus_ugt5_2 \
  "(bool->bitvector (bvugt (var a 5) (var b 5)))" > "$IMPLS_DIR/lakeroad_xilinx_ultrascale_plus_ugt5_2.v"

generate_instr lakeroad_xilinx_ultrascale_plus_ult3_2 \
  "(bool->bitvector (bvult (var a 3) (var b 3)))" > "$IMPLS_DIR/lakeroad_xilinx_ultrascale_plus_ult3_2.v"
