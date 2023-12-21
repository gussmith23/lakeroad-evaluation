(* use_dsp = "yes" *) module mult_0_stage_signed_12_bit(
	input signed [11:0] a,
	input signed [11:0] b,
	output [11:0] out
	);

	assign out = a * b;
endmodule
