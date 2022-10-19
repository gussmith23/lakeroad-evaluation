#!/usr/bin/env bash

set -e
set -u

THISDIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
LOGFILE="$THISDIR"/../lattice_resources.log

echo "" >"$LOGFILE"

# Get INSTRUCTIONS and BITWIDTHS

source "$THISDIR"/include.sh

[ -d "$1" ] || {
  echo "Usage: $0 <evaluation-results-dir>"
  exit 1
}

EVAL_RESULTS_DIR="$1"
LATTICE_DIR="$EVAL_RESULTS_DIR/lattice_ecp5"
BASELINE_DIR="$EVAL_RESULTS_DIR/baseline/yosys_nextpnr"

export PATH="$THISDIR:$PATH"

# UNCOMMENT THE FOLLOWING LINES TO GENERATE FULL TABLE RATHER THAN DATA ALONE

# echo '\begin{tabular}{lr|rrrr|rrrr}'
# echo 'Instr & Bits & \multicolumn{4}{c}{Lakeroad} & \multicolumn{4}{c}{Baseline} \\'
# echo '            &          & Logic & Carry & PFMUX & L6MUX21   & Logic & Carry & PFMUX & L6MUX21          \\\hline\hline'

for instr in "${INSTRUCTIONS[@]}"; do

  for bitwidth in "${BITWIDTHS[@]}"; do
    # LAKEROAD RESOURCES
    synth_log_file="$(find "$LATTICE_DIR" -path "*${instr}${bitwidth}_*/*" -type f -name "yosys_log.txt")"
    pnr_log_file="$(find "$LATTICE_DIR" -path "*${instr}${bitwidth}_*/*" -type f -name "nextpnr_log.txt")"
    [ -e "$synth_log_file" ] || {
      echo "Skipping $instr$bitwidth: synth log file '$synth_log_file' does not exist" >>"$LOGFILE"
      continue
    }
    [ -e "$pnr_log_file" ] || {
      echo "Skipping $instr$bitwidth: pnr log file '$pnr_log_file' does not exist" >>"$LOGFILE"
      continue
    }

    lr_LOGIC="$(print_nextpnr_resource "$pnr_log_file" "logic LUTs:")"
    lr_CARRY="$(print_nextpnr_resource "$pnr_log_file" "carry LUTs:")"
    lr_PFUMX="$(print_yosys_resource "$synth_log_file" PFUMX)"
    lr_L6MUX21="$(print_yosys_resource "$synth_log_file" L6MUX21)"

    # BASELINE TIMES

    # XXX: I'm doing some hacky business...I'm assigning w/ a glob, and this
    # doesn't work unless I put it in an array. But there is only one match per
    # glob, so when I expand the array later I am not actually losing any info.

    synth_log_file="$(find "$BASELINE_DIR" -type f -name "*${instr}${bitwidth}_*.sv_yosys.log")"
    pnr_log_file="$(find "$BASELINE_DIR" -type f -name "*${instr}${bitwidth}_*.sv_nextpnr.log")"
    [ -e "$synth_log_file" ] || {
      echo "Skipping $instr$bitwidth: baseline synth log file '$synth_log_file' does not exist" >>"$LOGFILE"
      continue
    }
    [ -e "$pnr_log_file" ] || {
      echo "Skipping $instr$bitwidth: baseline pnr log file '$pnr_log_file' does not exist" >>"$LOGFILE"
      continue
    }

    bl_LOGIC="$(print_nextpnr_resource "$pnr_log_file" "logic LUTs:")"
    bl_CARRY="$(print_nextpnr_resource "$pnr_log_file" "carry LUTs:")"
    bl_PFUMX="$(print_yosys_resource "$synth_log_file" PFUMX)"
    bl_L6MUX21="$(print_yosys_resource "$synth_log_file" L6MUX21)"

    echo "$instr  & $bitwidth & $lr_LOGIC & $lr_CARRY & $lr_PFUMX & $lr_L6MUX21 & $bl_LOGIC & $bl_CARRY & $bl_PFUMX & $bl_L6MUX21 \\\\"

  done
done

# UNCOMMENT FOLLOWING LINE TO GENERATE FULL TABLE RATHER THAN DATA ALONE
#
# echo '\end{tabular}'
