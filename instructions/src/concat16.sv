module example(input [15:0] a, input [15:0] b, output [31:0] out);
  assign out = {a, b};
endmodule
