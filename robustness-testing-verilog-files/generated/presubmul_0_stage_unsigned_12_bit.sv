(* use_dsp = "yes" *) module presubmul_0_stage_unsigned_12_bit(
	input  [11:0] a,
	input  [11:0] b,
	input  [11:0] c,
	input  [11:0] d,
	output [11:0] out
	);

	assign out = (d - a) * b;
endmodule
