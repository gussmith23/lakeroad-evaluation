(* use_dsp = "yes" *) module muladd_0_stage_signed_11_bit(
	input signed [10:0] a,
	input signed [10:0] b,
	input signed [10:0] c,
	output [10:0] out
	);

	assign out = (a * b) + c;
endmodule
