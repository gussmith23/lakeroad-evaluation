set -e
set -u

: "$EVAL_OUTPUT_DIR"
export EVAL_OUTPUT_DIR="$EVAL_OUTPUT_DIR/xilinx-ultrascale-plus-vivado-eval/"
mkdir -p $EVAL_OUTPUT_DIR

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

$SCRIPT_DIR/compare-fud-resource-estimates.sh
$SCRIPT_DIR/vivado-synth-opt-place-route.sh
$SCRIPT_DIR/vivado-synth-opt-place-route-lakeroad-ultrascale-instrs.sh
$SCRIPT_DIR/vivado-synth-opt-place-route-behavioral-instrs.sh