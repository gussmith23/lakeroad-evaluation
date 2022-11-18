// Module used to test the Lakeroad pass in Yosys. 
// See python/yosys_experiments.py.
module test_sub_squared16(input [15:0] a, input [15:0] b, output [15:0] out);
  assign out = (a - b) * (a - b);
endmodule