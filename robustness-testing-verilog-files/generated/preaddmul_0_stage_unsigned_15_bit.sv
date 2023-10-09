(* use_dsp = "yes" *) module preaddmul_0_stage_unsigned_15_bit(
	input  [14:0] a,
	input  [14:0] b,
	input  [14:0] d,
	output [14:0] out
	);

	assign out = (d + a) * b;
endmodule
