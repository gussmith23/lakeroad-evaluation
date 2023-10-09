(* use_dsp = "yes" *) module muladd_0_stage_signed_18_bit(
	input signed [17:0] a,
	input signed [17:0] b,
	input signed [17:0] c,
	output [17:0] out
	);

	assign out = (a * b) + c;
endmodule
