(* use_dsp = "yes" *)
module mux (input [47:0] a, b, input s, output [47:0] out);
  assign out = s ? a : b;
endmodule
