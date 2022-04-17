#!/usr/bin/env bash

set -e

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
pushd "$THISDIR" > /dev/null

[ -e out ] && rm -rf out
mkdir out

for module in src/* ; do
    cp "$module" example.sv
    base=$(basename "$module")
    echo "Visiting on $base"

    # Same thing, but now we synthesize for Lattice ECP5. We can also place and
    # route for ECP5 using nextpnr-ecp5.
    yosys -s synthesize-ecp5.ys | tee synthesize-ecp5.log
    NUM_LUTS=$(sed -nr "s/[[:space:]]*LUT4[[:space:]]*([0-9]+)[[:space:]]*/\1/p" synthesize-ecp5.log)
    if [ "$(echo "$NUM_LUTS" | wc -l)" -ne "1" ]; then exit 1; fi
    if [ "$NUM_LUTS" -ne 1 ]; then echo "wrong number of LUTs found"; exit 1; fi

    nextpnr-ecp5 --json synth-ecp5.json 2>&1 | tee nextpnr-ecp5.log
    NUM_LUTS=$(sed -nr "s/.*logic LUTs:[[:space:]]*([0-9]+)\/.*/\1/p" nextpnr-ecp5.log)
    if [ "$(echo "$NUM_LUTS" | wc -l)" -ne 1 ]; then exit 1; fi
    if [ "$NUM_LUTS" -ne "1" ]; then echo "wrong number of LUTs found"; exit 1; fi

    mv synth-ecp5.json out/"$base".json
    mv synthesize-ecp5.log out/"$base".log
    mv synthesize-ecp5.ys out/"$base".ys


done
popd > /dev/null