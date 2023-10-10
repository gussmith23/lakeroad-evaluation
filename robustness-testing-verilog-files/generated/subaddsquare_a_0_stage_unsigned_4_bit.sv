(* use_dsp = "yes" *) module subaddsquare_a_0_stage_unsigned_4_bit(
	input  [3:0] a,
	input  [3:0] c,
	input  [3:0] d,
	output [3:0] out,
	input clk);

	assign out = c - ((d + a) * (d + a));
endmodule
