(* use_dsp = "yes" *) module submuladd_0_stage_signed_17_bit(
	input signed [16:0] a,
	input signed [16:0] b,
	input signed [16:0] c,
	input signed [16:0] d,
	output [16:0] out
	);

	assign out = ((d - a) * b) + c;
endmodule
