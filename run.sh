# Fail if any of these commands fail!
set -e

cd lakeroad
./run-tests.sh
cd

cd yosys-example
./run.sh
cd
