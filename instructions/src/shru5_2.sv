module shru5_2(input unsigned [4:0] a, input unsigned [4:0] b, output unsigned[4:0] out);
  assign out = a >> b;
endmodule
