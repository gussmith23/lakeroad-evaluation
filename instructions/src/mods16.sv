module example(input signed[15:0] a, input signed[15:0] b, output signed[15:0] out);
  assign out = a % b;
endmodule
