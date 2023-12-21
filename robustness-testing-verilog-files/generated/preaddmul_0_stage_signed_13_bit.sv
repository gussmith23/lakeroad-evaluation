(* use_dsp = "yes" *) module preaddmul_0_stage_signed_13_bit(
	input signed [12:0] a,
	input signed [12:0] b,
	input signed [12:0] d,
	output [12:0] out
	);

	assign out = (d + a) * b;
endmodule
