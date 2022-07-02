create_project -force "add" "out" -part "xczu3eg-sbva484-1-e"

read_verilog -sv lakeroad.v
read_xdc -mode "out_of_context" constraints.xdc

synth_design -mode "out_of_context" -top "main"
write_verilog "netlist.v"
place_design -directive Default
route_design -directive Default
report_utilization -file "util.txt"
report_timing -file "timing.txt"
report_timing_summary -check_timing_verbose -file "timing_sum.txt"
