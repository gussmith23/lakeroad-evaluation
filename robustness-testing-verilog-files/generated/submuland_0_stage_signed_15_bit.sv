(* use_dsp = "yes" *) module submuland_0_stage_signed_15_bit(
	input signed [14:0] a,
	input signed [14:0] b,
	input signed [14:0] c,
	input signed [14:0] d,
	output [14:0] out
	);

	assign out = ((d - a) * b) & c;
endmodule
