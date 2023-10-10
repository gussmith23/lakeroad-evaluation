(* use_dsp = "yes" *) module mulor_0_stage_signed_9_bit(
	input signed [8:0] a,
	input signed [8:0] b,
	input signed [8:0] c,
	output [8:0] out
	);

	assign out = (a * b) | c;
endmodule
