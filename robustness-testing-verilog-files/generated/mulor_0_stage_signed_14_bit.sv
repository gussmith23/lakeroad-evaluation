(* use_dsp = "yes" *) module mulor_0_stage_signed_14_bit(
	input signed [13:0] a,
	input signed [13:0] b,
	input signed [13:0] c,
	output [13:0] out
	);

	assign out = (a * b) | c;
endmodule
