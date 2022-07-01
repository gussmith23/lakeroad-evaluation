set -e
set -u

: "$EVAL_OUTPUT_DIR"
export EVAL_OUTPUT_DIR="$EVAL_OUTPUT_DIR/xilinx-ultrascale-plus-vivado-eval/"
mkdir -p $EVAL_OUTPUT_DIR

./compare-fud-resource-estimates.sh
./vivado-synth-opt-place-route.sh
./vivado-synth-opt-place-route-instrs.sh