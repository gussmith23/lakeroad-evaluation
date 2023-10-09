(* use_dsp = "yes" *) module mulor_0_stage_unsigned_17_bit(
	input  [16:0] a,
	input  [16:0] b,
	input  [16:0] c,
	output [16:0] out
	);

	assign out = (a * b) | c;
endmodule
