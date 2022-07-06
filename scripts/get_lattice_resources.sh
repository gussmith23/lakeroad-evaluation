#!/usr/bin/env bash

set -e 
set -u

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

print_yosys_resource () {
    file="$1"
    resource="$2"
    r=$(awk "/^ *$resource/"' {print $2}' "$file" | xargs)
    if [ -z "$r" ] || [ "$r" -eq 0 ]; then echo ""; else echo "$r"; fi
}

print_nextpnr_resource () {
    file="$1"
    resource="$2"
    r=$(awk "/$resource/"'{print $4}' "$file" | cut -d/ -f1 | xargs)
    if [ -z "$r" ] || [ "$r" -eq 0 ]; then echo ""; else echo "$r"; fi

}

echo '\begin{tabular}{lr|rrrr|rrrr}'
echo 'Instr & Bits & \multicolumn{4}{c}{Lakeroad} & \multicolumn{4}{c}{Baseline} \\'
echo '            &          & Logic & Carry & PFMUX & L6MUX21   & Logic & Carry & PFMUX & L6MUX21          \\\hline\hline'
for instr in add sub and or not; do

  for bitwidth in 1 8 32; do
    # LAKEROAD RESOURCES
    synth_log_file=("$THISDIR/../yosys-synth-opt-place-route-lattice-instrs/lakeroad_lattice_ecp5_${instr}${bitwidth}_"*-synth.log)
    pnr_log_file=("$THISDIR/../yosys-synth-opt-place-route-lattice-instrs/lakeroad_lattice_ecp5_${instr}${bitwidth}_"*-nextpnr.log)

    lr_LOGIC="$(print_nextpnr_resource "$pnr_log_file"   "logic LUTs:" )"
    lr_CARRY="$(print_nextpnr_resource "$pnr_log_file"   "carry LUTs:" )"
    lr_PFUMX="$(print_yosys_resource   "$synth_log_file" PFUMX)"
    lr_L6MUX21="$(print_yosys_resource "$synth_log_file" L6MUX21)"

    # BASELINE TIMES

    # XXX: I'm doing some hacky business...I'm assigning w/ a glob, and this
    # doesn't work unless I put it in an array. But there is only one match per
    # glob, so when I expand the array later I am not actually losing any info.

    synth_log_file="$THISDIR/../instructions/logs/${instr}${bitwidth}-synthesize-ecp5.log"
    pnr_log_file="$THISDIR/../instructions/logs/${instr}${bitwidth}-nextpnr-ecp5.log"

    bl_LOGIC="$(print_nextpnr_resource "$pnr_log_file"   "logic LUTs:" )"
    bl_CARRY="$(print_nextpnr_resource "$pnr_log_file"   "carry LUTs:" )"
    bl_PFUMX="$(print_yosys_resource   "$synth_log_file" PFUMX)"
    bl_L6MUX21="$(print_yosys_resource "$synth_log_file" L6MUX21)"

    echo "$instr  & $bitwidth & $lr_LOGIC & $lr_CARRY & $lr_PFUMX & $lr_L6MUX21 & $bl_LOGIC & $bl_CARRY & $bl_PFUMX & $bl_L6MUX21 \\\\"

  done
done
echo '\end{tabular}'
