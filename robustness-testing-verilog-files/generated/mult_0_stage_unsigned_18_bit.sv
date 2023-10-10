(* use_dsp = "yes" *) module mult_0_stage_unsigned_18_bit(
	input  [17:0] a,
	input  [17:0] b,
	output [17:0] out
	);

	assign out = a * b;
endmodule
