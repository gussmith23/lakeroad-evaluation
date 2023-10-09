(* use_dsp = "yes" *) module mult_0_stage_unsigned_9_bit(
	input  [8:0] a,
	input  [8:0] b,
	output [8:0] out
	);

	assign out = a * b;
endmodule
