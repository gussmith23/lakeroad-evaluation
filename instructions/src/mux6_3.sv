module mux6_3(input s, input [5:0] a, input [5:0] b, output [5:0] out);
  assign out = s ? a : b;
endmodule
