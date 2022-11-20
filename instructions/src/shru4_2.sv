module shru4_2(input unsigned [3:0] a, input unsigned [3:0] b, output unsigned[3:0] out);
  assign out = a >> b;
endmodule
