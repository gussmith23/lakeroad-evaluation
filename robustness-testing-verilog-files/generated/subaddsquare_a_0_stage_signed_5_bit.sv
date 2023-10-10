(* use_dsp = "yes" *) module subaddsquare_a_0_stage_signed_5_bit(
	input signed [4:0] a,
	input signed [4:0] c,
	input signed [4:0] d,
	output [4:0] out,
	input clk);

	assign out = c - ((d + a) * (d + a));
endmodule
