module mux32_3(input s, input [31:0] a, input [31:0] b, output [31:0] out);
  assign out = s ? a : b;
endmodule
