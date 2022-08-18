if { $argc != 3 } {
  error "Incorrect number of arguments. Expects <sv_source_file>, <output_files_filename_base>, <module name>"
}

set sv_source_file [ lindex $argv 0 ]
set base [ lindex $argv 1 ]
set modname [ lindex $argv 2 ]

read_verilog -sv ${sv_source_file}
set_property top ${modname} [current_fileset]
synth_design -mode out_of_context
opt_design
place_design
route_design
write_verilog ${modname}_synth_opt_place_route.sv