(* use_dsp = "yes" *) module preaddmul_0_stage_unsigned_9_bit(
	input  [8:0] a,
	input  [8:0] b,
	input  [8:0] d,
	output [8:0] out
	);

	assign out = (d + a) * b;
endmodule
