module replicate2_16(input [15:0] a, output [31:0] out);
  assign out = {a, a};
endmodule