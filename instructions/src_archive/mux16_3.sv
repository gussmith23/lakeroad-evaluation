module mux16_3(input s, input [15:0] a, input [15:0] b, output [15:0] out);
  assign out = s ? a : b;
endmodule
