(* use_dsp = "yes" *) module addmulsub_0_stage_signed_9_bit(
	input signed [8:0] a,
	input signed [8:0] b,
	input signed [8:0] c,
	input signed [8:0] d,
	output [8:0] out
	);

	assign out = ((d + a) * b) - c;
endmodule
