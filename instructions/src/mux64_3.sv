module mux64_3(input s, input [63:0] a, input [63:0] b, output [63:0] out);
  assign out = s ? a : b;
endmodule
