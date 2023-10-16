(* use_dsp = "yes" *)
module xor_reduction_12 (input [11:0] a, output out);
  assign out = ^a;
endmodule
