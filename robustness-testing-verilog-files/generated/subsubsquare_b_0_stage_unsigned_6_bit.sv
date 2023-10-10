(* use_dsp = "yes" *) module subsubsquare_b_0_stage_unsigned_6_bit(
	input  [5:0] b,
	input  [5:0] c,
	input  [5:0] d,
	output [5:0] out,
	input clk);

	assign out = c - ((d - b) * (d - b));
endmodule
