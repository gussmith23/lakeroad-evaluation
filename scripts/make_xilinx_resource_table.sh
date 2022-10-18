#!/usr/bin/env bash

set -e
set -u

[ -d "$1" ] || {
  echo "Usage: $0 <evaluation-results-dir>"
  exit 1
}

THISDIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
LOGFILE="$THISDIR"/../xilinx_resources.log
echo "" >"$LOGFILE"

# Get INSTRUCTIONS and BITWIDTHS
source "$THISDIR"/include.sh

EVAL_RESULTS_DIR="$1"
XILINX_DIR="$EVAL_RESULTS_DIR/xilinx_ultrascale_plus"

export PATH="$THISDIR:$PATH"

# UNCOMMENT THE FOLLOWING LINES TO GENERATE FULL TABLE RATHER THAN DATA ALONE

# echo '\begin{tabular}{lr|rrrr|rrrr}'
# echo 'Instr & Bits & \multicolumn{4}{c}{Lakeroad} & \multicolumn{4}{c}{Baseline} \\'
# echo '            &          & Logic & Carry & PFMUX & L6MUX21   & Logic & Carry & PFMUX & L6MUX21          \\\hline\hline'

for instr in "${INSTRUCTIONS[@]}"; do

  for bitwidth in "${BITWIDTHS[@]}"; do
    # LAKEROAD RESOURCES
    vivado_log="$(find "$XILINX_DIR" -path "*${instr}${bitwidth}_*/*" -type f -name "vivado_log.txt")"
    [ -e "$vivado_log" ] || {
      echo "Skipping $instr$bitwidth: vivado log file '$vivado_log' does not exist" >>"$LOGFILE"
      continue
    }
    [ -e "$vivado_log" ] || {
      echo "Skipping $instr$bitwidth: vivado log file '$vivado_log' does not exist" >>"$THISDIR"/xilinx_resources.log
      continue
    }

    lr_LUT2="$(print_vivado_resource "$vivado_log" "LUT2")"
    lr_LUT6="$(print_vivado_resource "$vivado_log" "LUT6")"
    lr_LUT6_2="$(print_vivado_resource "$vivado_log" "LUT6_2")"
    lr_CARRY8="$(print_vivado_resource "$vivado_log" "CARRY8")"
    lr_MUX="$(print_vivado_resource "$vivado_log" "MUX")"
    echo "$lr_MUX"

    # BASELINE TIMES

    # XXX: I'm doing some hacky business...I'm assigning w/ a glob, and this
    # doesn't work unless I put it in an array. But there is only one match per
    # glob, so when I expand the array later I am not actually losing any info.

    vivado_log="todo"

    bl_LUT2=" "
    bl_LUT6=" "
    bl_LUT6_2=" "
    bl_CARRY8=" "
    bl_MUX=" "

    echo "$instr" \
      "& $bitwidth" \
      "& $lr_LUT2" \
      "& $lr_LUT6" \
      "& $lr_LUT6_2" \
      "& $lr_CARRY8" \
      "& $lr_MUX" \
      "& $bl_LUT2" \
      "& $bl_LUT6" \
      "& $bl_LUT6_2" \
      "& $bl_CARRY8" \
      "& $bl_MUX" \
      "\\\\"

  done
done

# UNCOMMENT FOLLOWING LINE TO GENERATE FULL TABLE RATHER THAN DATA ALONE
#
# echo '\end{tabular}'
