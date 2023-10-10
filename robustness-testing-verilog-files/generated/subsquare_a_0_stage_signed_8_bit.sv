(* use_dsp = "yes" *) module subsquare_a_0_stage_signed_8_bit(
	input signed [7:0] a,
	input signed [7:0] d,
	output [7:0] out,
	input clk);

	assign out = (d - a) * (d - a);
endmodule
