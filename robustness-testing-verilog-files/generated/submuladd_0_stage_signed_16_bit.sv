(* use_dsp = "yes" *) module submuladd_0_stage_signed_16_bit(
	input signed [15:0] a,
	input signed [15:0] b,
	input signed [15:0] c,
	input signed [15:0] d,
	output [15:0] out
	);

	assign out = ((d - a) * b) + c;
endmodule
