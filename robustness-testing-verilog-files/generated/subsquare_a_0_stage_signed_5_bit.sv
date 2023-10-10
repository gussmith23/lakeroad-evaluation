(* use_dsp = "yes" *) module subsquare_a_0_stage_signed_5_bit(
	input signed [4:0] a,
	input signed [4:0] d,
	output [4:0] out,
	input clk);

	assign out = (d - a) * (d - a);
endmodule
