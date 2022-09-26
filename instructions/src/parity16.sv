module parity16(input [15:0] a, output out);
  assign out = ~^a;
endmodule
