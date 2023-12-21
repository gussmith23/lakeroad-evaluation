(* use_dsp = "yes" *) module mulxor_0_stage_unsigned_11_bit(
	input  [10:0] a,
	input  [10:0] b,
	input  [10:0] c,
	output [10:0] out
	);

	assign out = (a * b) ^ c;
endmodule
