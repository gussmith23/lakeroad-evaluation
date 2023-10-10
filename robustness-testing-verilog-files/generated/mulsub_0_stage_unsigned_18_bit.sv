(* use_dsp = "yes" *) module mulsub_0_stage_unsigned_18_bit(
	input  [17:0] a,
	input  [17:0] b,
	input  [17:0] c,
	output [17:0] out
	);

	assign out = (a * b) - c;
endmodule
