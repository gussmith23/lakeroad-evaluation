(* use_dsp = "yes" *) module subsubsquare_a_0_stage_unsigned_8_bit(
	input  [7:0] a,
	input  [7:0] c,
	input  [7:0] d,
	output [7:0] out,
	input clk);

	assign out = c - ((d - a) * (d - a));
endmodule
