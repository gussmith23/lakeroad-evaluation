(* use_dsp = "yes" *) module mult_0_stage_unsigned_17_bit(
	input  [16:0] a,
	input  [16:0] b,
	output [16:0] out
	);

	assign out = a * b;
endmodule
