module example(input [0:0] sel, input [15:0] a, input [15:0] b, output [15:0] out);
  assign out = sel[0] ? b : a;
endmodule
