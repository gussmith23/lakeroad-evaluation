(* use_dsp = "yes" *) module preaddmul_0_stage_signed_11_bit(
	input signed [10:0] a,
	input signed [10:0] b,
	input signed [10:0] d,
	output [10:0] out
	);

	assign out = (d + a) * b;
endmodule
