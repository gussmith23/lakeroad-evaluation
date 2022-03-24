set -e

# TODO(@gussmith23) We need to run twice to produce LUTs, for some reason.
yosys -s synthesize.ys | tee synth.log

# Parses the number of LUT2s out of the results.
NUM_LUTS=$(sed -nr "s/[[:space:]]*LUT2[[:space:]]*([0-9]+)[[:space:]]*/\1/p" synth.log)

# NUM_LUTS should be one line long.
if [ $(echo $NUM_LUTS | wc -l) -ne "1" ]; then exit 1; fi

# There should be one LUT2.
if [ $NUM_LUTS -ne "1" ]; then echo "wrong number of LUTs found"; exit 1; fi