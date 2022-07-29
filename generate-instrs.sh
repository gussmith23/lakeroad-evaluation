#!/bin/bash
# Script which generates all instructions and inserts them

set -e
set -u
set -x

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
BASE_DIR="$SCRIPT_DIR"

: "$EVAL_OUTPUT_DIR"
export EVAL_OUTPUT_DIR="$EVAL_OUTPUT_DIR/instruction-impls/"
mkdir -p $EVAL_OUTPUT_DIR

IMPLS_DIR="$BASE_DIR/lattice-ecp5-impls" ./generate-calyx-lattice-ecp5-impls.sh
IMPLS_DIR="$BASE_DIR/xilinx-ultrascale-plus-impls" ./generate-xilinx-ultrascale-plus-impls.sh
IMPLS_DIR="$BASE_DIR/sofa-impls" ./generate-sofa-impls.sh