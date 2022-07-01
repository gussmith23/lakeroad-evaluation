if { $argc != 3 } {
  error "Incorrect number of arguments. Expects <sv_source_file>, <output_files_filename_base>, <module name>"
}

set sv_source_file [ lindex $argv 0 ]
set base [ lindex $argv 1 ]
set modname [ lindex $argv 2 ]

read_verilog -sv $sv_source_file

set stage "synth"
synth_design -mode "out_of_context" -top "$modname" -part "xczu3eg-sbva484-1-e"
write_verilog -force -file "$base-$stage.v"
report_utilization -force -file "$base-util-$stage.txt"
report_timing -file "$base-timing-$stage.txt"

set stage "opt"
opt_design
write_verilog -force -file "$base-$stage.v"
report_utilization -force -file "$base-util-$stage.txt"
report_timing -file "$base-timing-$stage.txt"

set stage "place"
place_design -directive Default
write_verilog -force -file "$base-$stage.v"
report_utilization -force -file "$base-util-$stage.txt"
report_timing -file "$base-timing-$stage.txt"

set stage "route"
route_design -directive Default
write_verilog -force -file "$base-$stage.v"
report_utilization -force -file "$base-util-$stage.txt"
report_timing -file "$base-timing-$stage.txt"