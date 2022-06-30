set -e
set -u

: "$EVAL_OUTPUT_DIR"
export EVAL_OUTPUT_DIR="$EVAL_OUTPUT_DIR/vivado-synth-opt-place-route/"
mkdir -p $EVAL_OUTPUT_DIR

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
BASE_DIR="$SCRIPT_DIR/../"

# Fail if the .futil files between our two repos are different.
diff <(find "$BASE_DIR/calyx/" -name '*.futil' -type f -printf "%f\n") <(find "$BASE_DIR/calyx-xilinx-ultrascale-plus/" -name '*.futil' -type f -printf "%f\n") || exit 1

run_vivado () {
  local futil_filename="$1"
  local basename=$(basename $futil_filename)
  local all_outputs_filename_base="$EVAL_OUTPUT_DIR/$basename"

  echo "Compiling with vanilla Calyx..."
  local vanilla_calyx_filename_base="$all_outputs_filename_base-vanilla"
  local vanilla_calyx_verilog_source="$vanilla_calyx_filename_base.v"
  $BASE_DIR/calyx/bin/fud e --to synth-verilog $futil_filename > $vanilla_calyx_verilog_source
  echo "Running vanilla Calyx version through Vivado..."
  vivado -mode batch -source "$SCRIPT_DIR/vivado-synth-opt-place-route.tcl" -tclargs "$vanilla_calyx_verilog_source" "$vanilla_calyx_filename_base"

  echo "Compiling with UltraScale Calyx..."
  local ultrascale_calyx_filename_base="$all_outputs_filename_base-ultrascale"
  local ultrascale_calyx_verilog_source="$ultrascale_calyx_filename_base.v"
  $BASE_DIR/calyx-xilinx-ultrascale-plus/bin/fud e --to synth-verilog $futil_filename > $ultrascale_calyx_verilog_source
  echo "Running UltraScale Calyx version through Vivado..."
  vivado -mode batch -source "$SCRIPT_DIR/vivado-synth-opt-place-route.tcl" -tclargs "$ultrascale_calyx_verilog_source" "$ultrascale_calyx_filename_base"
}

# Ignore ref.futil, as it throws an error from FUD.
futil_files=$(find $BASE_DIR/calyx/tests/correctness/ \( -name '*.futil' ! -wholename '*ref-cells/ref.futil' \) )
num_files=$(echo "$futil_files" | wc -l)
i=0
for futil_file in $futil_files ; do
  echo "$(($i+1)) of $num_files"
  run_vivado "$futil_file"
  ((i=i+1))
done