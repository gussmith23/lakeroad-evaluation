(* use_dsp = "yes" *)
module xor_reduction_96 (input [95:0] a, output out);
  assign out = ^a;
endmodule
