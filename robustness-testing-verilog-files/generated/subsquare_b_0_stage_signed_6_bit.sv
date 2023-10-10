(* use_dsp = "yes" *) module subsquare_b_0_stage_signed_6_bit(
	input signed [5:0] b,
	input signed [5:0] d,
	output [5:0] out,
	input clk);

	assign out = (d - b) * (d - b);
endmodule
