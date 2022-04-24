#!/bin/bash

# Fail if any of these commands fail!
set -e

pushd lakeroad
# Note: ALWAYS use source! This lets us fail if any commands in these scripts fail.
source run-tests.sh
popd

pushd yosys-example
source run.sh
popd
