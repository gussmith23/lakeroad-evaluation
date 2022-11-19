module mux5_3(input s, input [4:0] a, input [4:0] b, output [4:0] out);
  assign out = s ? a : b;
endmodule
