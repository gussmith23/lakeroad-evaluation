#!/usr/bin/env bash

set -e
set -o pipefail   # Get exit code of `yosys .. | tee`

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
pushd "$THISDIR" > /dev/null

[ -e out ] && rm -rf out
[ -e logs ] && rm -rf logs
mkdir out
mkdir logs

for module in src/* ; do
    cp "$module" module.sv
    base=$(basename "$module")
    printf "\n\033[32;1m[ ================    Visiting Module %s    ================ ]\033[0m\n\n" "$base"

    # Same thing, but now we synthesize for Lattice ECP5. We can also place and
    # route for ECP5 using nextpnr-ecp5.
    echo "[ + ] Running yosys -s synthesize-ecp5.ys"
    yosys -s synthesize-ecp5.ys > synthesize-ecp5.log
    yosys_result=$?

    if [ $yosys_result -ne 0 ]; then 
        echo "[ ! ] Error: running yosys on $base resulted in exit code $yosys_result. Continuing..."
        continue 
    fi

    # Cache results of run in `out` and `logs`
    mv synthesize-ecp5.log "logs/$base-synthesize-ecp5.log"
    mv synth-ecp5.json "out/$base-synth-ecp5.json"
    mv synth-ecp5.sv "out/$base-synth-ecp5.sv"

    echo "      -> Yosys completed and the following files were generated:"
    echo "      -> Logs:    logs/$base-synthesize-ecp5.log"
    echo "      -> JSON:    out/$base-synth-ecp5.json"
    echo "      -> Verilog: out/$base-synth-ecp5.sv"

    NUM_LUTS=$(sed -nr "s/[[:space:]]*LUT4[[:space:]]*([0-9]+)[[:space:]]*/\1/p" "logs/$base-synthesize-ecp5.log")
    echo "[ + ] NUM_LUTS: $NUM_LUTS"

    if [ "$(echo "$NUM_LUTS" | wc -l)" -ne "1" ]; then
        echo "[ ! ] Error: bad NUM_LUTS: Wrong number of lines (expected 1):"
        echo "vvvvvvvvvv"
        echo "$NUM_LUTS"
        echo "^^^^^^^^^^"
        echo "      ...continuing"
        continue
    fi

    if [ "$NUM_LUTS" -ne 1 ]; then 
        echo "[ ! ] Wrong number of LUTs found: expected 1 but found $NUM_LUTS"
        echo "      ...continuing"
        continue
    fi

    echo "[ + ] Running nextpnr-ecp5 --json out/$base-synth-ecp5.json"
    nextpnr-ecp5 --json "out/$base-synth-ecp5.json" > "logs/$base-nextpnr-ecp5.log" 2>&1
    nextpnr_result=$?
    echo "      -> Nextprn complete."
    echo "      -> Summary can be found at logs/$base-nextpnr-ecp5.log"

    if [ $nextpnr_result -ne 0 ]; then 
        echo "[ ! ] Error: running nextpnr on $base resulted in exit code $nextpnr_result"
        echo "      ...continuing"
        continue 
    fi

    if [ "$NUM_LUTS" -ne 1 ]; then 
        echo "[ ! ] Wrong number of LUTs found: expected 1 but found $NUM_LUTS"
        echo "      ...continuing"
        continue
    fi
    NUM_LUTS=$(sed -nr "s/.*logic LUTs:[[:space:]]*([0-9]+)\/.*/\1/p" nextpnr-ecp5.log)
    if [ "$(echo "$NUM_LUTS" | wc -l)" -ne 1 ]; then
        echo "[ ! ] Wrong number of LUTs found: expected 1 but found $NUM_LUTS"
        echo "      ...continuing"

    fi
    if [ "$NUM_LUTS" -ne "1" ]; then echo "wrong number of LUTs found"; exit 1; fi

done
popd > /dev/null