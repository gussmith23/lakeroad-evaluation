#!/usr/bin/env bash

set -e
set -o pipefail   # Get exit code of `yosys .. | tee`

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

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
    yosys -s synthesize-ecp5.ys > "logs/$inst-synthesize-ecp5.log"
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
    if [ "$NUM_LUTS" != "$expected_luts" ]; then 
        printf "\033[31;1m[ ! ] Wrong number of LUTs found: expected %s but found %s\033[0m\n" "$expected_luts" "$NUM_LUTS"
        echo "      ...continuing"
        errors+=( "$inst" )
        return 1
    fi

    echo "[ + ] Running nextpnr-ecp5 --json out/$inst-synth-ecp5.json"
    nextpnr-ecp5 --json "out/$inst-synth-ecp5.json" > "logs/$inst-nextpnr-ecp5.log" 2>&1
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
    if [ "$NUM_LUTS" != "$expected_luts" ]; then 
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
            run_on_module "$(basename "$module")"
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

################################################################################
# Auto-generated to check against regressions
function expected_synthesized_luts {
    case "$1" in
        add16)
            echo 66
            ;;
        add8)
            echo 25
            ;;
        and16)
            echo 16
            ;;
        and8)
            echo 8
            ;;
        concat16)
            echo
            ;;
        concat8)
            echo
            ;;
        divs)
            echo 25
            ;;
        divs16)
            echo 1207
            ;;
        divs8)
            echo 333
            ;;
        divu)
            echo 25
            ;;
        divu16)
            echo 933
            ;;
        divu8)
            echo 221
            ;;
        mods16)
            echo 1161
            ;;
        mods8)
            echo 323
            ;;
        modu16)
            echo 833
            ;;
        modu8)
            echo 261
            ;;
        mul16)
            echo 601
            ;;
        mul8)
            echo 112
            ;;
        mux16)
            echo 8
            ;;
        mux8)
            echo 16
            ;;
        or16)
            echo 16
            ;;
        or8)
            echo 8
            ;;
        parity16)
            echo
            ;;
        parity8)
            echo
            ;;
        replicate2_16)
            echo
            ;;
        replicate2_8)
            echo
            ;;
        replicate3_8)
            echo
            ;;
        shl16)
            echo 149
            ;;
        shl8)
            echo 89
            ;;
        shrs16)
            echo 200
            ;;
        shrs8)
            echo 54
            ;;
        shru16)
            echo 200
            ;;
        shru8)
            echo 54
            ;;
        sub16)
            echo 66
            ;;
        sub8)
            echo 25
            ;;
        xor16)
            echo 16
            ;;
        xor8)
            echo 8
            ;;
        *)
            echo "ERROR! No such input $1"
            ;;
    esac
}

################################################################################
# Auto-generated to check against regressions
function expected_pnr_luts {
    case "$1" in
        add16)
            echo 66
            ;;
        add8)
            echo 25
            ;;
        and16)
            echo 16
            ;;
        and8)
            echo 8
            ;;
        concat16)
            echo 0
            ;;
        concat8)
            echo 0
            ;;
        divs16)
            echo 1207
            ;;
        divs8)
            echo 333
            ;;
        divu)
            echo 25
            ;;
        divu16)
            echo 933
            ;;
        divu8)
            echo 221
            ;;
        mods16)
            echo 1161
            ;;
        mods8)
            echo 323
            ;;
        modu16)
            echo 833
            ;;
        modu8)
            echo 261
            ;;
        mul16)
            echo 601
            ;;
        mul8)
            echo 112
            ;;
        mux16)
            echo 8
            ;;
        mux8)
            echo 16
            ;;
        or16)
            echo 16
            ;;
        or8)
            echo 8
            ;;
        parity16)
            echo 0
            ;;
        parity8)
            echo 0
            ;;
        replicate2_16)
            echo 0
            ;;
        replicate2_8)
            echo 0
            ;;
        replicate3_8)
            echo 0
            ;;
        shl16)
            echo 149
            ;;
        shl8)
            echo 89
            ;;
        shrs16)
            echo 200
            ;;
        shrs8)
            echo 54
            ;;
        shru16)
            echo 200
            ;;
        shru8)
            echo 54
            ;;
        sub16)
            echo 66
            ;;
        sub8)
            echo 25
            ;;
        xor16)
            echo 16
            ;;
        xor8)
            echo 8
            ;;
        *)
            echo "ERROR! No such input $1"
            ;;
    esac
}

main "$@"