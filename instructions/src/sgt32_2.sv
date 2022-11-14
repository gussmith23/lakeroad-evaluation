module sgt32_2(input signed[31:0] a, input signed[31:0] b, output signed out);
  assign out = a > b;
endmodule
