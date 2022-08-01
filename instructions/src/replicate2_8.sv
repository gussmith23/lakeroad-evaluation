module replicate2_8(input [7:0] a, output [15:0] out);
  assign out = {a, a};
endmodule