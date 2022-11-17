// Module used to test the Lakeroad pass in Yosys. 
// See python/yosys_experiments.py.
module test_add_mul_add16(input [15:0] a, input [15:0] b, input [15:0] c, input [15:0] d, output [15:0] out);
  assign out = (a + b) * c + d;
endmodule