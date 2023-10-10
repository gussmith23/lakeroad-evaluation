(* use_dsp = "yes" *) module submulor_0_stage_unsigned_13_bit(
	input  [12:0] a,
	input  [12:0] b,
	input  [12:0] c,
	input  [12:0] d,
	output [12:0] out
	);

	assign out = ((d - a) * b) | c;
endmodule
