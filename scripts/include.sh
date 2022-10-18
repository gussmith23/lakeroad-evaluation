#!/usr/bin/bash

set -e

# Value to add in to tables for empty cells
ZERO_PLACE_HOLDER=""

# Instructions to iterate over
INSTRUCTIONS=(add and not mul mux sub)

# Bitwidths of instructions to iterate over
BITWIDTHS=(1 8 32 64 128)

# Declare all of the above values to be read only and exported
declare -arx INSTRUCTIONS
declare -arx BITWIDTHS
declare -rx ZERO_PLACE_HOLDER
