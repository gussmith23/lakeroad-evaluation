module mux7_3(input s, input [6:0] a, input [6:0] b, output [6:0] out);
  assign out = s ? a : b;
endmodule
