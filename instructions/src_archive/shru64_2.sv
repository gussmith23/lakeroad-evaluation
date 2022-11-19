module shru64_2(input unsigned[63:0] a, input unsigned[63:0] b, output unsigned[63:0] out);
  assign out = a >> b;
endmodule
