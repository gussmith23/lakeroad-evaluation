(* use_dsp = "yes" *) module subaddsquare_b_0_stage_unsigned_5_bit(
	input  [4:0] b,
	input  [4:0] c,
	input  [4:0] d,
	output [4:0] out,
	input clk);

	assign out = c - ((d + b) * (d + b));
endmodule
