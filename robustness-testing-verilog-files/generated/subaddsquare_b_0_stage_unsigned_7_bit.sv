(* use_dsp = "yes" *) module subaddsquare_b_0_stage_unsigned_7_bit(
	input  [6:0] b,
	input  [6:0] c,
	input  [6:0] d,
	output [6:0] out,
	input clk);

	assign out = c - ((d + b) * (d + b));
endmodule
