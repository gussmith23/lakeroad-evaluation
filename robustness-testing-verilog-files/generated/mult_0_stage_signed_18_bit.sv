(* use_dsp = "yes" *) module mult_0_stage_signed_18_bit(
	input signed [17:0] a,
	input signed [17:0] b,
	output [17:0] out
	);

	assign out = a * b;
endmodule
