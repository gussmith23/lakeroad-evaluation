(* use_dsp = "yes" *) module subaddsquare_a_0_stage_signed_1_bit(
	input signed [0:0] a,
	input signed [0:0] c,
	input signed [0:0] d,
	output [0:0] out,
	input clk);

	assign out = c - ((d + a) * (d + a));
endmodule
