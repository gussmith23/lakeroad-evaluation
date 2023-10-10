(* use_dsp = "yes" *) module presubmul_0_stage_unsigned_14_bit(
	input  [13:0] a,
	input  [13:0] b,
	input  [13:0] c,
	input  [13:0] d,
	output [13:0] out
	);

	assign out = (d - a) * b;
endmodule
