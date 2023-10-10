(* use_dsp = "yes" *) module subaddsquare_b_0_stage_unsigned_3_bit(
	input  [2:0] b,
	input  [2:0] c,
	input  [2:0] d,
	output [2:0] out,
	input clk);

	assign out = c - ((d + b) * (d + b));
endmodule
