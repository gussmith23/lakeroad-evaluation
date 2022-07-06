set -e
set -u 
set -x

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
BASE_DIR="$SCRIPT_DIR"

: "$EVAL_OUTPUT_DIR"
export EVAL_OUTPUT_DIR="$EVAL_OUTPUT_DIR/vivado-eval"
mkdir -p $EVAL_OUTPUT_DIR

source "$BASE_DIR/xilinx-ultrascale-plus-vivado-eval/run.sh"
source "$BASE_DIR/luis-vector-add-not-using-carry-example/run-vivado.sh"