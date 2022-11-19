module ult64_2(input unsigned[63:0] a, input unsigned[63:0] b, output unsigned out);
  assign out = a < b;
endmodule
