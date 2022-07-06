# This script is currently broken, as it seems like Yosys doesn't support modern SV features.
set -e
set -u

: "$EVAL_OUTPUT_DIR"
export EVAL_OUTPUT_DIR="$EVAL_OUTPUT_DIR/yosys-vector-add-motivating-example/"
mkdir -p $EVAL_OUTPUT_DIR

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

run_yosys_nextpnr () {
  local filename="$1"
  local basename=$(basename $filename)
  local output_file_base="$EVAL_OUTPUT_DIR/$basename"
  yosys -p "
read -sv $filename
proc; opt; techmap; opt
synth_ecp5
write_verilog $output_file_base-netlist.v
stat"
  nextpnr "$basename-netlist.v"
}

run_yosys_nextpnr $SCRIPT_DIR/manual-in-out-reg.v
run_yosys_nextpnr $SCRIPT_DIR/manual-in-reg.v
run_yosys_nextpnr $SCRIPT_DIR/manual-out-reg.v
run_yosys_nextpnr $SCRIPT_DIR/manual-no-reg.v
run_yosys_nextpnr $SCRIPT_DIR/behavioral-in-out-reg.v
run_yosys_nextpnr $SCRIPT_DIR/behavioral-in-reg.v
run_yosys_nextpnr $SCRIPT_DIR/behavioral-out-reg.v
run_yosys_nextpnr $SCRIPT_DIR/behavioral-no-reg.v