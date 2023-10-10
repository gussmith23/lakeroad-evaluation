(* use_dsp = "yes" *) module subaddsquare_a_0_stage_unsigned_1_bit(
	input  [0:0] a,
	input  [0:0] c,
	input  [0:0] d,
	output [0:0] out,
	input clk);

	assign out = c - ((d + a) * (d + a));
endmodule
