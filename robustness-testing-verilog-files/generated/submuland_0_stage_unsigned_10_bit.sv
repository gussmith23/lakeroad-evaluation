(* use_dsp = "yes" *) module submuland_0_stage_unsigned_10_bit(
	input  [9:0] a,
	input  [9:0] b,
	input  [9:0] c,
	input  [9:0] d,
	output [9:0] out
	);

	assign out = ((d - a) * b) & c;
endmodule
