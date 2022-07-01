#!/bin/bash
# Generate implementations of various instructions for Xilinx UltraScale+ and
# put them into Calyx.

set -e
set -u

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
IMPLS_DIR="$SCRIPT_DIR/xilinx_ultrascale_plus_impls"

# Insert them into the file. Note that this doesn't delete any existing code, so
# you might have to clean up old code.
sed -i.orig '/^\/\/ BEGIN GENERATED LAKEROAD CODE$/r '<(cat $IMPLS_DIR/*) "$SCRIPT_DIR/calyx-xilinx-ultrascale-plus/primitives/core.sv"