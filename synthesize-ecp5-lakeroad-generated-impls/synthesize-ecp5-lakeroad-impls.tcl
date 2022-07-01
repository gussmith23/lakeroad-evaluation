set sv_source_file $::env(VLOG_FILE_NAME)
set base $::env(OUTPUT_FILE_BASE)
set modname $::env(MOD_NAME)

yosys read_verilog -sv "$sv_source_file"
yosys hierarchy -top "$modname"
yosys synth_ecp5
yosys write_verilog "$base-synth.v"
yosys write_json "$base-synth.json"
exit