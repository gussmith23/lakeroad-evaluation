(* use_dsp = "yes" *) module subaddsquare_a_0_stage_unsigned_2_bit(
	input  [1:0] a,
	input  [1:0] c,
	input  [1:0] d,
	output [1:0] out,
	input clk);

	assign out = c - ((d + a) * (d + a));
endmodule
