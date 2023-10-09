(* use_dsp = "yes" *) module submuladd_0_stage_signed_18_bit(
	input signed [17:0] a,
	input signed [17:0] b,
	input signed [17:0] c,
	input signed [17:0] d,
	output [17:0] out
	);

	assign out = ((d - a) * b) + c;
endmodule
