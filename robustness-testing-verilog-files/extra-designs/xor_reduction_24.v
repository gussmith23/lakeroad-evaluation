(* use_dsp = "yes" *)
module xor_reduction_24 (input [23:0] a, output out);
  assign out = ^a;
endmodule
