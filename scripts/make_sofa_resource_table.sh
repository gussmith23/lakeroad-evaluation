#!/usr/bin/env bash

set -e
set -u

THISDIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
LOGFILE="$THISDIR"/../sofa_resources.log
echo "" >"$LOGFILE"

# Get INSTRUCTIONS and BITWIDTHS

source "$THISDIR"/include.sh

[ -d "$1" ] || {
  echo "Usage: $0 <evaluation-results-dir>"
  exit 1
}

EVAL_RESULTS_DIR="$1"
SOFA_DIR="$EVAL_RESULTS_DIR/sofa"

export PATH="$THISDIR:$PATH"

# UNCOMMENT THE FOLLOWING LINES TO GENERATE FULL TABLE RATHER THAN DATA ALONE

# echo '\begin{tabular}{lr|rrrr|rrrr}'
# echo 'Instr & Bits & \multicolumn{4}{c}{Lakeroad} & \multicolumn{4}{c}{Baseline} \\'
# echo '            &          & Logic & Carry & PFMUX & L6MUX21   & Logic & Carry & PFMUX & L6MUX21          \\\hline\hline'

for instr in "${INSTRUCTIONS[@]}"; do

  for bitwidth in "${BITWIDTHS[@]}"; do
    # LAKEROAD RESOURCES
    sofa_sv="$(find "$SOFA_DIR" -path "*${instr}${bitwidth}_*/*" -type f -name "lakeroad_sofa_${instr}${bitwidth}_*.sv")"
    [ -e "$sofa_sv" ] || {
      echo "Skipping $instr$bitwidth: sofa verilog file '$sofa_sv' does not exist" >>"$LOGFILE"
      continue
    }

    lr_LUT4="$(print_sofa_resource "$sofa_sv" "frac_lut4")"

    # BASELINE TIMES

    # XXX: I'm doing some hacky business...I'm assigning w/ a glob, and this
    # doesn't work unless I put it in an array. But there is only one match per
    # glob, so when I expand the array later I am not actually losing any info.

    sofa_sv="todo"

    bl_LUT4=" - "

    echo "$instr  & $bitwidth & $lr_LUT4 & $bl_LUT4 \\\\"

  done
done

# UNCOMMENT FOLLOWING LINE TO GENERATE FULL TABLE RATHER THAN DATA ALONE
#
# echo '\end{tabular}'
