(* use_dsp = "yes" *) module subaddsquare_b_0_stage_unsigned_8_bit(
	input  [7:0] b,
	input  [7:0] c,
	input  [7:0] d,
	output [7:0] out,
	input clk);

	assign out = c - ((d + b) * (d + b));
endmodule
