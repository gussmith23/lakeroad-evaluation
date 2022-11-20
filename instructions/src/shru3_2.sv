module shru3_2(input unsigned [2:0] a, input unsigned [2:0] b, output unsigned[2:0] out);
  assign out = a >> b;
endmodule
