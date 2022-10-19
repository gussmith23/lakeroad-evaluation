#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 <evaluation-results> <output-dir>" >&2
    exit 1
fi

[ -e "$1" ] || {
    echo "File '$1' does not exist" >&2
    exit 1
}

[ -d "$2" ] || {
    echo "Directory '$2' does not exist" >&2
    exit 1
}

TABLE_OUTPUT_DIR="$(realpath "$2")"

THISDIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
echo "+-----------------------------------+"
echo "| Generating Lattice Resource Table |"
echo "+-----------------------------------+"
echo

"$THISDIR"/make_lattice_resource_table.sh "$1" >"$TABLE_OUTPUT_DIR"/lattice-resource-table.tex

echo "Wrote table body to $TABLE_OUTPUT_DIR/lattice_resource_table.tex"
echo

echo "+-----------------------------------+"
echo "| Generating Xilinx Resource Table  |"
echo "+-----------------------------------+"
echo

"$THISDIR"/make_xilinx_resource_table.sh "$1" >"$TABLE_OUTPUT_DIR"/xilinx-resource-table.tex

echo "Wrote table body to $TABLE_OUTPUT_DIR/xilinx_resource_table.tex"
echo

echo "+-----------------------------------+"
echo "| Generating Sofa Resource Table    |"
echo "+-----------------------------------+"
echo

"$THISDIR"/make_sofa_resource_table.sh "$1" >"$TABLE_OUTPUT_DIR"/sofa-resource-table.tex

echo "Wrote table body to $TABLE_OUTPUT_DIR/sofa_resource_table.tex"
