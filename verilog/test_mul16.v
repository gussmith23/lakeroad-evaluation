// Module used to test the Lakeroad pass in Yosys. 
// See python/yosys_experiments.py.
module test_mul16(input [7:0] a, input [7:0] b, output [7:0] out);
  assign out = a * b;
endmodule