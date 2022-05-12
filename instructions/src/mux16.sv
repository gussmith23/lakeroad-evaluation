module example(input [0:0] sel, input [7:0] a, input [7:0] b, output [7:0] out);
  assign out = sel[0] ? b : a;
endmodule
