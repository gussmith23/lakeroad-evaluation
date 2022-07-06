#!/usr/bin/env bash

################################################################################
# Helper module with some lookups for regression proofing our suite. We define
# two functions here:
# 1. expected_synthesized_luts: this encodes how many luts we expect to see
#    post yosys synthesis
# 2. expected_pnr_luts : this encodes how many luts we expect to see after
#    place and route
#
# These functions were initially auto-generated but I've updated them to match
# newly added instructions (e.g., extract*)
#
# This file is meant to be sourced by `run.sh` and is factored out for
# readibility.
################################################################################

################################################################################
# Auto-generated to check against regressions
function expected_synthesized_luts {
    case "$1" in
        add1)
            echo 1
            ;;
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
        extract*)
            echo
            ;;
        icmp_ge8)
            echo 18
            ;;
        icmp_gt8)
            echo 16
            ;;
        icmp_le8)
            echo 16
            ;;
        icmp_lt8)
            echo 18
            ;;
        icmp_ge16)
            echo 33
            ;;
        icmp_gt16)
            echo 33
            ;;
        icmp_le16)
            echo 33
            ;;
        icmp_lt16)
            echo 33
            ;;
        icmp_eq8)
            echo 5
            ;;
        icmp_eq16)
            echo 12
            ;;
        icmp_ne8)
            echo 5
            ;;
        icmp_ne16)
            echo 12
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
        extract*)
            echo 0
            ;;
        icmp_le8)
            echo 16
            ;;
        icmp_lt8)
            echo 18
            ;;
        icmp_ge8)
            echo 18
            ;;
        icmp_gt8)
            echo 16
            ;;
        icmp_ge16)
            echo 33
            ;;
        icmp_gt16)
            echo 33
            ;;
        icmp_le16)
            echo 33
            ;;
        icmp_lt16)
            echo 33
            ;;
        icmp_eq8)
            echo 5
            ;;
        icmp_eq16)
            echo 12
            ;;
        icmp_ne8)
            echo 5
            ;;
        icmp_ne16)
            echo 12
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