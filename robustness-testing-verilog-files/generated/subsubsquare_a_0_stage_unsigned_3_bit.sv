(* use_dsp = "yes" *) module subsubsquare_a_0_stage_unsigned_3_bit(
	input  [2:0] a,
	input  [2:0] c,
	input  [2:0] d,
	output [2:0] out,
	input clk);

	assign out = c - ((d - a) * (d - a));
endmodule
