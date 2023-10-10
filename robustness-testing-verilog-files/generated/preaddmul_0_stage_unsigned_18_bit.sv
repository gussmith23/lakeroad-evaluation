(* use_dsp = "yes" *) module preaddmul_0_stage_unsigned_18_bit(
	input  [17:0] a,
	input  [17:0] b,
	input  [17:0] d,
	output [17:0] out
	);

	assign out = (d + a) * b;
endmodule
