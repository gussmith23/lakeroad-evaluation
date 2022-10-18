#!/usr/bin/bash

set -e

INSTRUCTIONS=(add and not mul mux sub)
BITWIDTHS=(1 8 32 64 128)
declare -arx INSTRUCTIONS
declare -arx BITWIDTHS
