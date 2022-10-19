#!/usr/bin/bash

set -e

# Value to add in to tables for empty cells
ZERO_PLACE_HOLDER=""

# Instructions to iterate over
INSTRUCTIONS=(add and not mul mux sub)

# Bitwidths of instructions to iterate over
BITWIDTHS=(1 8 32 64 128)

# Returns arguement as an int: default to 0 if not in standard int form
function as_int {
    if [[ "$1" =~ ^-?[0-9]+$ ]]; then
        echo "$1"
    else
        echo 0
    fi
}

# Declare all of the above values to be read only and exported
declare -arx INSTRUCTIONS
declare -arx BITWIDTHS
declare -rx ZERO_PLACE_HOLDER
declare -fx as_int
