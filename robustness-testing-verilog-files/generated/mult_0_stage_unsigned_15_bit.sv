(* use_dsp = "yes" *) module mult_0_stage_unsigned_15_bit(
	input  [14:0] a,
	input  [14:0] b,
	output [14:0] out
	);

	assign out = a * b;
endmodule
