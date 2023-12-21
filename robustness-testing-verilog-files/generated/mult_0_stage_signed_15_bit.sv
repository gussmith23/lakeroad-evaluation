(* use_dsp = "yes" *) module mult_0_stage_signed_15_bit(
	input signed [14:0] a,
	input signed [14:0] b,
	output [14:0] out
	);

	assign out = a * b;
endmodule
