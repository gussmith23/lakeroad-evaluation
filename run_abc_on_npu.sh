yosys -p "
  read_verilog -sv fpga-npu/rtl/mvu_sched.sv 
  read_verilog -sv fpga-npu/rtl/fifo.sv 
  read_verilog -sv fpga-npu/rtl/scfifo.sv 
  hierarchy -top mvu_sched
  synth
  abc"
