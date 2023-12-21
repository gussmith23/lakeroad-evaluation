(* use_dsp = "yes" *) module preaddmul_0_stage_signed_10_bit(
	input signed [9:0] a,
	input signed [9:0] b,
	input signed [9:0] d,
	output [9:0] out
	);

	assign out = (d + a) * b;
endmodule
