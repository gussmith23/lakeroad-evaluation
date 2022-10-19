module mux2_3(input s, input [1:0] a, input [1:0] b, output [1:0] out);
  assign out = s ? a : b;
endmodule
