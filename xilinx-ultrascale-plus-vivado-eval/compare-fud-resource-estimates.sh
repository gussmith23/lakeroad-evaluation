#!/bin/bash

set -e
set -u

: "$EVAL_OUTPUT_DIR"

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
BASE_DIR="$SCRIPT_DIR/.."

export EVAL_OUTPUT_DIR="$EVAL_OUTPUT_DIR/compare-fud-resource-estimates/"
mkdir -p $EVAL_OUTPUT_DIR

# Fail if the .futil files between our two repos are different.
diff <(find "$BASE_DIR/calyx/" -name '*.futil' -type f -printf "%f\n") <(find "$BASE_DIR/calyx-xilinx-ultrascale-plus/" -name '*.futil' -type f -printf "%f\n") || exit 1

fud_resource_estimates () {
  local futil_file="$1"

  echo "================================================"
  echo $futil_file
  echo "Running vanilla Calyx..."
  vanilla_calyx_output=$($BASE_DIR/calyx/bin/fud e --to resource-estimate $futil_file)
  echo $vanilla_calyx_output
  echo $vanilla_calyx_output > "$EVAL_OUTPUT_DIR/$(basename $futil_file).vanilla-calyx"
  echo
  echo "Running Xilinx UltraScale+ Calyx..."
  ultrascale_calyx_output=$($BASE_DIR/calyx-xilinx-ultrascale-plus/bin/fud e --to resource-estimate $futil_file)
  echo $ultrascale_calyx_output
  echo $ultrascale_calyx_output > "$EVAL_OUTPUT_DIR/$(basename $futil_file).xilinx-ultrascale-plus-calyx"
  echo "================================================"
}

# Ignore ref-cells files, as they throw errors from fud.
futil_files=$(find $BASE_DIR/calyx/tests/correctness/ \( -name '*.futil' ! -wholename '*ref-cells/*' \) )
num_files=$(echo "$futil_files" | wc -l)
i=0
for futil_file in $futil_files ; do
  echo "$(($i+1)) of $num_files"
  fud_resource_estimates "$futil_file"
  ((i=i+1))
done
