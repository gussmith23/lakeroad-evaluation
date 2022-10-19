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

function log {
  echo "$1" >&2
  echo "$1" >>"$LOGFILE"
}

# Get INSTRUCTIONS and BITWIDTHS
source "$THISDIR"/include.sh

EVAL_RESULTS_DIR="$1"
XILINX_DIR="$EVAL_RESULTS_DIR/xilinx_ultrascale_plus"
BASELINE_DIR="$EVAL_RESULTS_DIR/baseline/vivado"

export PATH="$THISDIR:$PATH"

# UNCOMMENT THE FOLLOWING LINES TO GENERATE FULL TABLE RATHER THAN DATA ALONE

# echo '\begin{tabular}{lr|rrrr|rrrr}'
# echo 'Instr & Bits & \multicolumn{4}{c}{Lakeroad} & \multicolumn{4}{c}{Baseline} \\'
# echo '            &          & Logic & Carry & PFMUX & L6MUX21   & Logic & Carry & PFMUX & L6MUX21          \\\hline\hline'

for instr in "${INSTRUCTIONS[@]}"; do

  for bitwidth in "${BITWIDTHS[@]}"; do
    # LAKEROAD RESOURCES
    used_dsp=false
    vivado_logs="$(find "$XILINX_DIR" -path "*${instr}${bitwidth}_*/*" -type f -name "vivado_log.txt")"

    # We might get back multiple vivado_logs, one for a DSP and one without
    # THIS ASSUMES NO WHITESPACE IN PATHNAMES
    # THIS ALSO ASSUMES A SINGLE NON-DSP IMPLEMENTATION AT MOST

    vivado_log=""
    for fname in $vivado_logs; do
      if [[ "$fname" == *-dsp* ]]; then
        used_dsp=true
      else
        vivado_log="$fname"
      fi
    done

    [ -e "$vivado_log" ] || {
      log "Skipping $instr$bitwidth: Vivado log file '$vivado_log' does not exist"
      continue
    }

    lr_LUT2="$(print_vivado_resource "$vivado_log" "LUT2")"
    lr_LUT6="$(print_vivado_resource "$vivado_log" "LUT6")"
    lr_LUT6_2="$(print_vivado_resource "$vivado_log" "LUT6_2")"
    lr_LUTs=$(($(as_int "$lr_LUT2") + $(as_int "$lr_LUT6") + $(as_int "$lr_LUT6_2")))
    lr_CARRY8="$(print_vivado_resource "$vivado_log" "CARRY8")"
    lr_DSP="$(if $used_dsp; then echo '\checkmark'; else echo ""; fi)"

    # BASELINE TIMES

    # XXX: I'm doing some hacky business...I'm assigning w/ a glob, and this
    # doesn't work unless I put it in an array. But there is only one match per
    # glob, so when I expand the array later I am not actually losing any info.

    vivado_log="$(find "$BASELINE_DIR" -type f -name "${instr}${bitwidth}_*.log")"
    [ -e "$vivado_log" ] || {
      log "Skipping $instr$bitwidth: baseline vivado log file '$vivado_log' does not exist"
    }

    bl_LUT2="$(print_vivado_resource "$vivado_log" "LUT2")"
    bl_LUT3="$(print_vivado_resource "$vivado_log" "LUT3")"
    bl_LUT4="$(print_vivado_resource "$vivado_log" "LUT4")"
    bl_LUT5="$(print_vivado_resource "$vivado_log" "LUT5")"
    bl_LUT6="$(print_vivado_resource "$vivado_log" "LUT6")"
    bl_LUT6_2="$(print_vivado_resource "$vivado_log" "LUT6_2")"
    bl_LUTs=$(($(as_int "$bl_LUT2") + $(as_int "$bl_LUT6") + $(as_int "$bl_LUT6_2") + $(as_int "$bl_LUT3") + $(as_int "$bl_LUT4") + $(as_int "$bl_LUT5")))
    [ $bl_LUTs -eq 0 ] && bl_LUTs=""
    bl_CARRY8="$(print_vivado_resource "$vivado_log" "CARRY8")"
    bl_DSP="$(print_vivado_resource "$vivado_log" "DSP48E2")"

    echo "$instr" \
      "& $bitwidth" \
      "& $lr_LUTs" \
      "& $lr_CARRY8" \
      "& $lr_DSP" \
      "& $bl_LUTs" \
      "& $bl_CARRY8" \
      "& $bl_DSP" \
      "\\\\"

  done
done
log "Finished processing all instructions"

# UNCOMMENT FOLLOWING LINE TO GENERATE FULL TABLE RATHER THAN DATA ALONE
#
# echo '\end{tabular}'
