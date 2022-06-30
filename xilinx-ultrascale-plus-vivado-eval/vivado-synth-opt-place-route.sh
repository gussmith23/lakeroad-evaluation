set -e
set -u

: "$EVAL_OUTPUT_DIR"
export EVAL_OUTPUT_DIR="$EVAL_OUTPUT_DIR/vivado-synth-opt-place-route/"
mkdir -p $EVAL_OUTPUT_DIR

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
BASE_DIR="$SCRIPT_DIR/../"

# Fail if the .futil files between our two repos are different.
diff <(find "$BASE_DIR/calyx/" -name '*.futil' -type f -printf "%f\n") <(find "$BASE_DIR/calyx-xilinx-ultrascale-plus/" -name '*.futil' -type f -printf "%f\n") || exit 1

# Ignore ref-cells files, as they throw errors from fud.
futil_files=$(find $BASE_DIR/calyx/tests/correctness/ \( -name '*.futil' ! -wholename '*ref-cells/*' \) )
num_files=$(echo "$futil_files" | wc -l)
i=0
for futil_file in $futil_files ; do
  echo "$(($i+1)) of $num_files"
  $SCRIPT_DIR/run-vivado-on-futil.sh "$futil_file"
  ((i=i+1))
done