module shru16_2(input unsigned [15:0] a, input unsigned [15:0] b, output unsigned[15:0] out);
  assign out = a >> b;
endmodule
