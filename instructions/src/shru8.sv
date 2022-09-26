module shru8(input unsigned[7:0] a, input unsigned[7:0] b, output unsigned[7:0] out);
  assign out = a >> b;
endmodule
