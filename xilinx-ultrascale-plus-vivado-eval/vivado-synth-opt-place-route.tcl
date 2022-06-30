if { $argc != 2 } {
  error "Incorrect number of arguments. Expects <sv_source_file>, <output_files_filename_base>"
}

set sv_source_file [ lindex $argv 0 ]
set base [ lindex $argv 1 ]

read_verilog -sv $sv_source_file

set stage "synth"
synth_design -mode "out_of_context" -top "main" -part "xczu3eg-sbva484-1-e"
write_verilog -force -file "$base-$stage.v"
report_utilization -force -file "$base-util-$stage.v"
report_timing_summary -file "$base-timing-summary-$stage.v"
report_timing -file "$base-timing-$stage.v"

create_clock -period 5 -name clk [get_ports clk]

set stage "opt"
opt_design
write_verilog -force -file "$base-$stage.v"
report_utilization -force -file "$base-util-$stage.v"
report_timing_summary -file "$base-timing-summary-$stage.v"
report_timing -file "$base-timing-$stage.v"

set stage "place"
place_design -directive Default
write_verilog -force -file "$base-$stage.v"
report_utilization -force -file "$base-util-$stage.v"
report_timing_summary -file "$base-timing-summary-$stage.v"
report_timing -file "$base-timing-$stage.v"

set stage "route"
route_design -directive Default
write_verilog -force -file "$base-$stage.v"
report_utilization -force -file "$base-util-$stage.v"
report_timing_summary -file "$base-timing-summary-$stage.v"
report_timing -file "$base-timing-$stage.v"