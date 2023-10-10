(* use_dsp = "yes" *) module subaddsquare_b_0_stage_unsigned_1_bit(
	input  [0:0] b,
	input  [0:0] c,
	input  [0:0] d,
	output [0:0] out,
	input clk);

	assign out = c - ((d + b) * (d + b));
endmodule
