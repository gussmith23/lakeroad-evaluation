(* use_dsp = "yes" *) module mulsub_0_stage_signed_10_bit(
	input signed [9:0] a,
	input signed [9:0] b,
	input signed [9:0] c,
	output [9:0] out
	);

	assign out = (a * b) - c;
endmodule
