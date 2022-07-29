#!/bin/bash

set -e
set -u

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
IMPLS_DIR="$SCRIPT_DIR/lattice_ecp5_impls"

# Clear old implementations, insert new ones into file.
sed -i -n '1,/BEGIN GENERATED LAKEROAD CODE/p;/END GENERATED LAKEROAD CODE/,$p' "$SCRIPT_DIR/calyx-lattice-ecp5/primitives/core.sv"
sed -i '/^\/\/ BEGIN GENERATED LAKEROAD CODE$/r '<(cat $IMPLS_DIR/*) "$SCRIPT_DIR/calyx-lattice-ecp5/primitives/core.sv"