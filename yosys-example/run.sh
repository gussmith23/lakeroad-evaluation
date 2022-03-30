set -e

# TODO(@gussmith23) We need to run twice to produce LUTs, for some reason.
yosys -s synthesize-xilinx.ys | tee synthesize-xilinx.log

# Parses the number of LUT2s out of the results.
NUM_LUTS=$(sed -nr "s/[[:space:]]*LUT2[[:space:]]*([0-9]+)[[:space:]]*/\1/p" synthesize-xilinx.log)

# NUM_LUTS should be one line long.
if [ $(echo $NUM_LUTS | wc -l) -ne "1" ]; then exit 1; fi

# There should be one LUT2.
if [ $NUM_LUTS -ne "1" ]; then echo "wrong number of LUTs found"; exit 1; fi

# Same thing, but now we synthesize for Lattice ECP5. We can also place and
# route for ECP5 using nextpnr-ecp5.
yosys -s synthesize-ecp5.ys | tee synthesize-ecp5.log
NUM_LUTS=$(sed -nr "s/[[:space:]]*LUT4[[:space:]]*([0-9]+)[[:space:]]*/\1/p" synthesize-ecp5.log)
if [ $(echo $NUM_LUTS | wc -l) -ne "1" ]; then exit 1; fi
if [ $NUM_LUTS -ne "1" ]; then echo "wrong number of LUTs found"; exit 1; fi

nextpnr-ecp5 --json synth-ecp5.json 2>&1 | tee nextpnr-ecp5.log
NUM_LUTS=$(sed -nr "s/.*logic LUTs:[[:space:]]*([0-9]+)\/.*/\1/p" nextpnr-ecp5.log)
if [ $(echo $NUM_LUTS | wc -l) -ne "1" ]; then exit 1; fi
if [ $NUM_LUTS -ne "1" ]; then echo "wrong number of LUTs found"; exit 1; fi