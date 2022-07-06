set -e
set -u

: "$EVAL_OUTPUT_DIR"
export EVAL_OUTPUT_DIR="$EVAL_OUTPUT_DIR/vivado-vector-add-motivating-example/"
mkdir -p $EVAL_OUTPUT_DIR

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

run_vivado () {
  local filename="$1"
  local basename=$(basename $filename)
  local output_file_base="$EVAL_OUTPUT_DIR/$basename"
  vivado -mode batch -source "$SCRIPT_DIR/run.tcl" -tclargs "$filename" "$output_file_base"
}

run_vivado $SCRIPT_DIR/manual-in-out-reg.v
run_vivado $SCRIPT_DIR/manual-in-reg.v
run_vivado $SCRIPT_DIR/manual-out-reg.v
run_vivado $SCRIPT_DIR/manual-no-reg.v
run_vivado $SCRIPT_DIR/behavioral-in-out-reg.v
run_vivado $SCRIPT_DIR/behavioral-in-reg.v
run_vivado $SCRIPT_DIR/behavioral-out-reg.v
run_vivado $SCRIPT_DIR/behavioral-no-reg.v