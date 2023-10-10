(* use_dsp = "yes" *) module mult_0_stage_unsigned_13_bit(
	input  [12:0] a,
	input  [12:0] b,
	output [12:0] out
	);

	assign out = a * b;
endmodule
