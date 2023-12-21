(* use_dsp = "yes" *) module muland_0_stage_unsigned_13_bit(
	input  [12:0] a,
	input  [12:0] b,
	input  [12:0] c,
	output [12:0] out
	);

	assign out = (a * b) & c;
endmodule
