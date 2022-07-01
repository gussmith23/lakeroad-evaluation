set -e
set -u

: "$EVAL_OUTPUT_DIR"
export EVAL_OUTPUT_DIR="$EVAL_OUTPUT_DIR/vivado-synth-opt-place-route-lakeroad-ultrascale-instrs/"
mkdir -p $EVAL_OUTPUT_DIR

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
BASE_DIR="$SCRIPT_DIR/../"

instr_files=$(find $BASE_DIR/xilinx_ultrascale_plus_impls -type f)
num_files=$(echo "$instr_files" | wc -l)
i=0
for instr_file in $instr_files ; do
  echo "$(($i+1)) of $num_files"
  basename=$(basename $instr_file)
  modulename="${basename%.*}"
  all_outputs_filename_base="$EVAL_OUTPUT_DIR/$basename"
  vivado -mode batch -source "$SCRIPT_DIR/vivado-synth-opt-place-route-instrs.tcl" -tclargs "$instr_file" "$all_outputs_filename_base" "$modulename"
  ((i=i+1))
done