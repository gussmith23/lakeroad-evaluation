# Fail if any of these commands fail!
set -e

cd lakeroad
# Note: ALWAYS use source! This lets us fail if any commands in these scripts fail.
source run-tests.sh
cd

cd yosys-example
source run.sh
cd
