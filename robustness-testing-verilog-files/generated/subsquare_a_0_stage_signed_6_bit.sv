(* use_dsp = "yes" *) module subsquare_a_0_stage_signed_6_bit(
	input signed [5:0] a,
	input signed [5:0] d,
	output [5:0] out,
	input clk);

	assign out = (d - a) * (d - a);
endmodule
