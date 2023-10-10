(* use_dsp = "yes" *) module mult_0_stage_signed_14_bit(
	input signed [13:0] a,
	input signed [13:0] b,
	output [13:0] out
	);

	assign out = a * b;
endmodule
