(* use_dsp = "yes" *) module mulor_0_stage_signed_8_bit(
	input signed [7:0] a,
	input signed [7:0] b,
	input signed [7:0] c,
	output [7:0] out
	);

	assign out = (a * b) | c;
endmodule
