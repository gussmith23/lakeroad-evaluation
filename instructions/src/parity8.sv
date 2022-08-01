module parity8(input [7:0] a, output out);
  assign out = ~^a;
endmodule
