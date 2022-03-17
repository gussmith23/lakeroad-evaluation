# Fail if any of these commands fail!
set -e

cd lakeroad
# Note: ALWAYS use .! This lets us fail if any commands in these scripts fail.
. run-tests.sh
cd

cd yosys-example
. run.sh
cd
