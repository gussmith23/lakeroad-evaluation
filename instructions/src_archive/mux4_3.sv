module mux4_3(input s, input [3:0] a, input [3:0] b, output [3:0] out);
  assign out = s ? a : b;
endmodule
