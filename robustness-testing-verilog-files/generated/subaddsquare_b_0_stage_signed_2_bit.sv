(* use_dsp = "yes" *) module subaddsquare_b_0_stage_signed_2_bit(
	input signed [1:0] b,
	input signed [1:0] c,
	input signed [1:0] d,
	output [1:0] out,
	input clk);

	assign out = c - ((d + b) * (d + b));
endmodule
