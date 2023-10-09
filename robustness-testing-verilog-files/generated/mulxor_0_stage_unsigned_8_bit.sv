(* use_dsp = "yes" *) module mulxor_0_stage_unsigned_8_bit(
	input  [7:0] a,
	input  [7:0] b,
	input  [7:0] c,
	output [7:0] out
	);

	assign out = (a * b) ^ c;
endmodule
