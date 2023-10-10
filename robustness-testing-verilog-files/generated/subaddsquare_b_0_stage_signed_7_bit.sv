(* use_dsp = "yes" *) module subaddsquare_b_0_stage_signed_7_bit(
	input signed [6:0] b,
	input signed [6:0] c,
	input signed [6:0] d,
	output [6:0] out,
	input clk);

	assign out = c - ((d + b) * (d + b));
endmodule
