(* use_dsp = "yes" *) module mult_0_stage_unsigned_16_bit(
	input  [15:0] a,
	input  [15:0] b,
	output [15:0] out
	);

	assign out = a * b;
endmodule
