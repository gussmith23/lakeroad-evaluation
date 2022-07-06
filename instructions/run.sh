#!/usr/bin/env bash

set -e
set -o pipefail   # Get exit code of `yosys .. | tee`

ENFORCE_EXPECTED_LUTS=false
THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# shellcheck source=expected_luts_lookup.sh
source "$THISDIR/expected_luts_lookup.sh"

errors=()
modules_run=0

################################################################################
# Run Yosys on the provided module name  (it must exist in `src`) and store
# outputs in `logs` and `out`.
# 
function run_on_module {

    modules_run=$((modules_run + 1))
    [ ! -e logs ] && mkdir logs
    [ ! -e out ] && mkdir out

    base="$1"
    module="src/$base"
    inst="$(echo "$base" | cut -d . -f 1)"

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
    time (yosys -s synthesize-ecp5.ys > "logs/$inst-synthesize-ecp5.log") 2> "logs/$inst-synthesize-ecp5.time"
    yosys_result=$?

    if [ $yosys_result -ne 0 ]; then 
        echo "[ ! ] Error: running yosys on $base resulted in exit code $yosys_result. Continuing..."
        errors+=( "$inst" )
        return 1 
    fi

    # Cache results of run in `out`
    mv synth-ecp5.json "out/$inst-synth-ecp5.json"
    mv synth-ecp5.sv "out/$inst-synth-ecp5.sv"

    echo "      -> Yosys completed and the following files were generated:"
    echo "      -> Logs:    logs/$inst-synthesize-ecp5.log"
    echo "      -> JSON:    out/$inst-synth-ecp5.json"
    echo "      -> Verilog: out/$inst-synth-ecp5.sv"

    NUM_LUTS=$(sed -nr "s/[[:space:]]*LUT4[[:space:]]*([0-9]+)[[:space:]]*/\1/p" "logs/$inst-synthesize-ecp5.log")

    [[ "$NUM_LUTS" =~ ^[0-9]*$ ]] || {
        printf "\033[31;1m[ ! ] Found invalid number of synthesized LUTs:\n    must be zero or more digits but found %s\033[0m\n" "$NUM_LUTS"
        echo "Invalid LUT: must be zero or more digits, but found: '$NUM_LUTS'";
        errors+=( "$inst" )
        return 1;
    }

    echo "[ + ] # Synthesized LUTS: $NUM_LUTS"

    expected_luts="$(expected_synthesized_luts "$inst")"
    if $ENFORCE_EXPECTED_LUTS && [ "$NUM_LUTS" != "$expected_luts" ]; then 
        printf "\033[31;1m[ ! ] Wrong number of LUTs found: expected %s but found %s\033[0m\n" "$expected_luts" "$NUM_LUTS"
        echo "      ...continuing"
        errors+=( "$inst" )
        return 1
    fi

    echo "[ + ] Running nextpnr-ecp5 --json out/$inst-synth-ecp5.json"
    time (nextpnr-ecp5 --json "out/$inst-synth-ecp5.json" > "logs/$inst-nextpnr-ecp5.log" 2>&1) 2> "logs/$inst-nextpnr-ecp5.time"
    nextpnr_result=$?
    echo "      -> Nextprn complete."
    echo "      -> Summary can be found at logs/$inst-nextpnr-ecp5.log"

    if [ $nextpnr_result -ne 0 ]; then 
        printf "\033[31;1m[ ! ] Error: running nextpnr on %s resulted in exit code %s\033[0m\n" "$inst" "$nextpnr_result"
        echo "      ...continuing"
        errors+=( "$inst" )
        return 1 
    fi

    NUM_LUTS=$(sed -nr "s/.*logic LUTs:[[:space:]]*([0-9]+)\/.*/\1/p" logs/"$inst"-nextpnr-ecp5.log)

    [[ "$NUM_LUTS" =~ ^[0-9]*$ ]] || {
        printf "\033[31;1m[ ! ] Error: Invalid number of PNR LUTs:\n    must be zero or more digits but found %s\033[0m\n" "$NUM_LUTS"
        echo "Invalid LUT: must be zero or more digits, but found: '$NUM_LUTS'";
        errors+=( "$inst" )
        return 1;
    }

    echo "[ + ] # PNR LUTS: $NUM_LUTS"

    expected_luts="$(expected_pnr_luts "$inst")"
    if $ENFORCE_EXPECTED_LUTS && [ "$NUM_LUTS" != "$expected_luts" ]; then 
        printf "\033[31;1m[ ! ] Error: wrong number of PNR LUTs found: expected %s but found %s\033[0m\n" "$expected_luts" "$NUM_LUTS"
        echo "      ...continuing"
        errors+=( "$inst" )
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
            run_on_module "$(basename "$module")" || :
        done
    fi

    echo
    echo

    printf "\033[32;1m === Completed run of Lattice ISA Baseline on %s modules ===\033[0m\n\n" "$modules_run"

    # Print errors
    if [ ${#errors[@]} -eq 0 ]; then
        printf "\033[32;1mCompleted without any errors\033[0m\n"
    else
        echo "Found ${#errors[@]} errors:"
        i=1
        for err in "${errors[@]}"; do
            printf "    \033[31;1m[ %i ] %s\033[0m\n" "$i" "$err"
            i=$((i + 1))
        done
    fi

    # Cleanup 
    [ -e module.sv ] && rm module.sv
    [ -e nextpnr-ecp5.log ] && rm nextpnr-ecp5.log

    popd > /dev/null

}

main "$@"