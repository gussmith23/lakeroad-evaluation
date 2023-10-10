(* use_dsp = "yes" *) module submulor_0_stage_unsigned_8_bit(
	input  [7:0] a,
	input  [7:0] b,
	input  [7:0] c,
	input  [7:0] d,
	output [7:0] out
	);

	assign out = ((d - a) * b) | c;
endmodule
