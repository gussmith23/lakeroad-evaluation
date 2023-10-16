(* use_dsp = "yes" *)
module xor_reduction_48 (input [47:0] a, output out);
  assign out = ^a;
endmodule
