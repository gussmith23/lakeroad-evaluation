#!/usr/bin/env bash

set -e 
set -u

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo '\begin{tabular}{cccccc}'
echo 'Instruction & Bitwidth & \multicolumn{2}{c}{Lakeroad} & \multicolumn{2}{c}{Baseline} \\'
echo '            &          & Synth           & PnR        & Synth       & PnR            \\\hline\hline'
for instr in add sub and or not; do

  for bitwidth in 1 8 32; do
    # LAKEROAD TIMES
    synth_time_file="$THISDIR/../instructions/logs/${instr}${bitwidth}-synthesize-ecp5.time"
    lr_synth_time=$(awk '/^real/ {print $2}' "$synth_time_file" | python3 $THISDIR/format_time_output.py)

    pnr_time_file="$THISDIR/../instructions/logs/${instr}${bitwidth}-nextpnr-ecp5.time"
    lr_pnr_time=$(awk '/^real/ {print $2}' "$synth_time_file" | python3 $THISDIR/format_time_output.py)

    # BASELINE TIMES

    # XXX: I'm doing some hacky business...I'm assigning w/ a glob, and this
    # doesn't work unless I put it in an array. But there is only one match per
    # glob, so when I expand the array later I am not actually losing any info.
    synth_time_file=("$THISDIR/../yosys-synth-opt-place-route-lattice-instrs/lakeroad_lattice_ecp5_${instr}${bitwidth}_"*-synth.time)
    baseline_synth_time=$(awk '/^real/ {print $2}' "$synth_time_file" | python3 $THISDIR/format_time_output.py)

    pnr_time_file=("$THISDIR/../yosys-synth-opt-place-route-lattice-instrs/lakeroad_lattice_ecp5_${instr}${bitwidth}_"*-nextpnr.time)
    baseline_pnr_time=$(awk '/^real/ {print $2}' "$pnr_time_file" | python3 $THISDIR/format_time_output.py)

    echo "$instr  & $bitwidth & $lr_synth_time & $lr_pnr_time & $baseline_synth_time & $baseline_pnr_time \\\\"

  done
done
echo '\end{tabular}'