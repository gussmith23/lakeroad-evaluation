#!/bin/bash
# Generate implementations of various instructions for Lattice ECP5 and
# put them into Calyx.

set -e
set -u

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
BASE_DIR="$SCRIPT_DIR"
IMPLS_DIR="$BASE_DIR/lattice_ecp5_impls"
[ -e "$IMPLS_DIR" ] && rm -rf "$IMPLS_DIR"
mkdir -p "$IMPLS_DIR"

generate_binary_instr () {
  instr_name="$1"
  op="$2"
  bw="$3"
  instr="($op (var a $bw) (var b $bw))"
  modname="lakeroad_lattice_ecp5_${instr_name}${bw}_1"
  filename="$IMPLS_DIR/$modname.v"
  generate_instr "$modname" "$instr" > "$filename"
}

generate_unary_instr () {
  instr_name="$1"
  op="$2"
  bw="$3"
  instr="($op (var a $bw))"
  modname="lakeroad_lattice_ecp5_${instr_name}${bw}_2"
  filename="$IMPLS_DIR/$modname.v"
  generate_instr "$modname" "$instr" > "$filename"
}

generate_instr () {
  local name="$1"
  local instr="$2"
  printf "\033[32;1mGenerating \033[0;1m%s\033[32;1m:\033[0;1m %s\033[0m\n" "$name" "$instr" >&2
  racket $SCRIPT_DIR/lakeroad/racket/main.rkt \
    --out-format verilog \
    --architecture lattice-ecp5 \
    --module-name "$name" \
    --instruction "$instr" \
    || printf "\033[31;1m[!] Error:\033[0m Could not generate instruction %s\n" "$instr" >&2
}

# Generate instructions.

# generate_instr lakeroad_lattice_ecp5_and1_2 \
#   "(bvand (var a 1) (var b 1))" > "$IMPLS_DIR/lakeroad_lattice_ecp5_and1_2.v"
for bw in $(seq 1 8) 16 24 32; do
  generate_binary_instr and bvand $bw
  generate_binary_instr or bvor $bw
  generate_binary_instr add bvadd $bw
  generate_binary_instr sub bvsub $bw
  generate_unary_instr not bvnot $bw
done

# generate_instr lakeroad_lattice_ecp5_and8_2 \
#   "(bvand (var a 8) (var b 8))" > "$IMPLS_DIR/lakeroad_lattice_ecp5_and8_2.v"
#  generate_instr lakeroad_lattice_ecp5_and32_2 \
#    "(bvand (var a 32) (var b 32))" > "$IMPLS_DIR/lakeroad_lattice_ecp5_and32_2.v"
  
# generate_instr lakeroad_lattice_ecp5_or1_2 \
#   "(bvor (var a 1) (var b 1))" > "$IMPLS_DIR/lakeroad_lattice_ecp5_or1_2.v"
# generate_instr lakeroad_lattice_ecp5_or8_2 \
#   "(bvor (var a 8) (var b 8))" > "$IMPLS_DIR/lakeroad_lattice_ecp5_or8_2.v"
  
# generate_instr lakeroad_lattice_ecp5_add1_2 \
#   "(bvadd (var a 1) (var b 1))" > "$IMPLS_DIR/lakeroad_lattice_ecp5_add1_2.v"
# generate_instr lakeroad_lattice_ecp5_add2_2 \
#   "(bvadd (var a 2) (var b 2))" > "$IMPLS_DIR/lakeroad_lattice_ecp5_add2_2.v"
# generate_instr lakeroad_lattice_ecp5_add3_2 \
#   "(bvadd (var a 3) (var b 3))" > "$IMPLS_DIR/lakeroad_lattice_ecp5_add3_2.v"
# generate_instr lakeroad_lattice_ecp5_add4_2 \
#   "(bvadd (var a 4) (var b 4))" > "$IMPLS_DIR/lakeroad_lattice_ecp5_add4_2.v"
# generate_instr lakeroad_lattice_ecp5_add8_2 \
#   "(bvadd (var a 8) (var b 8))" > "$IMPLS_DIR/lakeroad_lattice_ecp5_add8_2.v"
# generate_instr lakeroad_lattice_ecp5_add32_2 \
#   "(bvadd (var a 32) (var b 32))" > "$IMPLS_DIR/lakeroad_lattice_ecp5_add32_2.v"
  
# generate_instr lakeroad_lattice_ecp5_not8_2 \
#   "(bvnot (var a 8))" > "$IMPLS_DIR/lakeroad_lattice_ecp5_not8_2.v"
# generate_instr lakeroad_lattice_ecp5_not6_2 \
#   "(bvnot (var a 6))" > "$IMPLS_DIR/lakeroad_lattice_ecp5_not6_2.v"
# generate_instr lakeroad_lattice_ecp5_not5_2 \
#   "(bvnot (var a 5))" > "$IMPLS_DIR/lakeroad_lattice_ecp5_not5_2.v"
# generate_instr lakeroad_lattice_ecp5_not1_2 \
#   "(bvnot (var a 1))" > "$IMPLS_DIR/lakeroad_lattice_ecp5_not1_2.v"

# generate_instr lakeroad_lattice_ecp5_sub5_2 \
#   "(bvsub (var a 5) (var b 5))" > "$IMPLS_DIR/lakeroad_lattice_ecp5_sub5_2.v"
# generate_instr lakeroad_lattice_ecp5_sub6_2 \
#   "(bvsub (var a 6) (var b 6))" > "$IMPLS_DIR/lakeroad_lattice_ecp5_sub6_2.v"
# generate_instr lakeroad_lattice_ecp5_sub8_2 \
#   "(bvsub (var a 8) (var b 8))" > "$IMPLS_DIR/lakeroad_lattice_ecp5_sub8_2.v"
# generate_instr lakeroad_lattice_ecp5_sub32_2 \
#   "(bvsub (var a 32) (var b 32))" > "$IMPLS_DIR/lakeroad_lattice_ecp5_sub32_2.v"