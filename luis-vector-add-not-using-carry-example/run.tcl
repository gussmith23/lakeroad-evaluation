if { $argc != 2 } {
  error "<sv_source_file>, <output_files_filename_base>"
}

set sv_source_file [ lindex $argv 0 ]
set base [ lindex $argv 1 ]

create_project -force "add" "out" -part "xczu3eg-sbva484-1-e"

read_verilog -sv $sv_source_file
read_xdc -mode "out_of_context" constraints.xdc

synth_design -mode "out_of_context" -top "main"
write_verilog "$base-netlist.v"
place_design -directive Default
route_design -directive Default
report_utilization -file "$base-util.txt"
report_timing -file "$base-timing.txt"
