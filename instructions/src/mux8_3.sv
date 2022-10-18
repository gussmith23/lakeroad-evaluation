module mux8_3(input s, input [7:0] a, input [7:0] b, output [7:0] out);
  assign out = s ? a : b;
endmodule
