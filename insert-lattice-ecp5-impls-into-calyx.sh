#!/bin/bash

set -e
set -u

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
IMPLS_DIR="$SCRIPT_DIR/lattice_ecp5_impls"

# Insert them into the file. Note that this doesn't delete any existing code, so
# you might have to clean up old code.
sed -i.orig '/^\/\/ BEGIN GENERATED LAKEROAD CODE$/r '<(cat $IMPLS_DIR/*) "$SCRIPT_DIR/calyx-lattice-ecp5/primitives/core.sv"