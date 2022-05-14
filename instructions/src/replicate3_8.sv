module example(input [7:0] a, output [23:0] out);
  assign out = {a, a, a};
endmodule