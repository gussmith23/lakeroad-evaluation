#!/bin/bash
# Generate implementations of various instructions for Xilinx UltraScale+ and
# put them into Calyx.

set -e
set -u

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
IMPLS_DIR="$SCRIPT_DIR/xilinx_ultrascale_plus_impls"

# Clear old implementations, insert new ones into file.
sed -i -n '1,/BEGIN GENERATED LAKEROAD CODE/p;/END GENERATED LAKEROAD CODE/,$p' "$SCRIPT_DIR/calyx-xilinx-ultrascale-plus/primitives/core.sv"
sed -i '/^\/\/ BEGIN GENERATED LAKEROAD CODE$/r '<(cat $IMPLS_DIR/*) "$SCRIPT_DIR/calyx-xilinx-ultrascale-plus/primitives/core.sv"