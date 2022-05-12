#!/usr/bin/env bash

set -e
set -o pipefail   # Get exit code of `yosys .. | tee`

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


################################################################################
# Run Yosys on the provided module name  (it must exist in `src`) and store
# outputs in `logs` and `out`.
# 
function run_on_module {
    base="$1"
    module="src/$base"

    printf "\n\033[32;1m[ ================    Visiting Module %s    ================ ]\033[0m\n\n" "$base"

    [ -e "$module" ] || {
        echo "[ ! ] Module $module does not exist!"
        echo "      ...continuing"
        return 1
    }
    cp "$module" module.sv

    # Same thing, but now we synthesize for Lattice ECP5. We can also place and
    # route for ECP5 using nextpnr-ecp5.
    echo "[ + ] Running yosys -s synthesize-ecp5.ys"
    yosys -s synthesize-ecp5.ys > synthesize-ecp5.log
    yosys_result=$?

    if [ $yosys_result -ne 0 ]; then 
        echo "[ ! ] Error: running yosys on $base resulted in exit code $yosys_result. Continuing..."
        return 1 
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

    if [ -z "$NUM_LUTS" ] ; then
        echo "[ ! ] No LUTs were detected"
        echo "      ...continuing"
        return 1
    fi

    echo "[ + ] NUM_LUTS: $NUM_LUTS"

    if [ "$(echo "$NUM_LUTS" | wc -l)" -ne "1" ]; then
        echo "[ ! ] Error: bad NUM_LUTS: Wrong number of lines (expected 1):"
        echo "vvvvvvvvvv"
        echo "$NUM_LUTS"
        echo "^^^^^^^^^^"
        echo "      ...continuing"
        return 1
    fi

    if [ "$NUM_LUTS" -ne 1 ]; then 
        echo "[ ! ] Wrong number of LUTs found: expected 1 but found $NUM_LUTS"
        echo "      ...continuing"
        return 1
    fi

    echo "[ + ] Running nextpnr-ecp5 --json out/$base-synth-ecp5.json"
    nextpnr-ecp5 --json "out/$base-synth-ecp5.json" > "logs/$base-nextpnr-ecp5.log" 2>&1
    nextpnr_result=$?
    echo "      -> Nextprn complete."
    echo "      -> Summary can be found at logs/$base-nextpnr-ecp5.log"

    if [ $nextpnr_result -ne 0 ]; then 
        echo "[ ! ] Error: running nextpnr on $base resulted in exit code $nextpnr_result"
        echo "      ...continuing"
        return 1 
    fi

    NUM_LUTS=$(sed -nr "s/.*logic LUTs:[[:space:]]*([0-9]+)\/.*/\1/p" nextpnr-ecp5.log)

    if [ "$(echo "$NUM_LUTS" | wc -l)" -ne "1" ]; then
        echo "[ ! ] Error: bad NUM_LUTS: Wrong number of lines (expected 1):"
        echo "vvvvvvvvvv"
        echo "$NUM_LUTS"
        echo "^^^^^^^^^^"
        echo "      ...continuing"
        return 1
    fi


    if [ "$NUM_LUTS" -ne 1 ]; then 
        echo "[ ! ] Wrong number of LUTs found: expected 1 but found $NUM_LUTS"
        echo "      ...continuing"
        return 1
    fi

}

################################################################################
# Run Yosys on all modules listed in the `src` directory and store outputs in
# `logs` and `out`.
# 
function run_on_all_modules {
    for module in src/* ; do
        run_on_module "$(basename "$module")" || :
    done
}

function main {

    pushd "$THISDIR" > /dev/null

    # Setup work space
    [ -e out ] && rm -rf out
    [ -e logs ] && rm -rf logs
    mkdir out
    mkdir logs

    if [ $# = 0 ]; then
        run_on_all_modules
    else
        for module in $@; do
            run_on_module "$(basename "$module")"
        done
    fi

    # Cleanup 
    [ -e module.sv ] && rm module.sv
    [ -e nextpnr-ecp5.log ] && rm nextpnr-ecp5.log

    popd > /dev/null

}

main "$@"