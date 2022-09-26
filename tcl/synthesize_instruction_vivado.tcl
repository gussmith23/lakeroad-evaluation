if { $argc != 3 } {
  error "Incorrect number of arguments. Expects <sv_source_file>, <module name>, <synth_opt_place_route_output_filepath>"
}

set sv_source_file [ lindex $argv 0 ]
set modname [ lindex $argv 1 ]
set synth_opt_place_route_output_filepath [ lindex $argv 2 ]

# Part number chosen at Luis's suggestion. Can be changed to another UltraScale+
# part.
set_part xczu3eg-sbva484-1-e

read_verilog -sv ${sv_source_file}
set_property top ${modname} [current_fileset]
synth_design -mode out_of_context
opt_design
place_design
# -release_memory seems to fix a bug where routing crashes when used inside the
# Docker container.
route_design -release_memory
write_verilog ${synth_opt_place_route_output_filepath}