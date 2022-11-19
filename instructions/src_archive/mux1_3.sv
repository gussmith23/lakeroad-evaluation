module mux1_3(input s, input [0:0] a, input [0:0] b, output [0:0] out);
  assign out = s ? a : b;
endmodule
