module ule32_2(input unsigned[31:0] a, input unsigned[31:0] b, output unsigned[31:0] out);
  assign out = a <= b;
endmodule
