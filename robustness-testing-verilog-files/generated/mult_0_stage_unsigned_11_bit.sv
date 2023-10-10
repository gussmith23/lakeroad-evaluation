(* use_dsp = "yes" *) module mult_0_stage_unsigned_11_bit(
	input  [10:0] a,
	input  [10:0] b,
	output [10:0] out
	);

	assign out = a * b;
endmodule
