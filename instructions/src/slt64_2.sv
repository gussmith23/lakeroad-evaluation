module slt64_2(input signed [63:0] a, input signed [63:0] b, output signed out);
  assign out = a < b;
endmodule
