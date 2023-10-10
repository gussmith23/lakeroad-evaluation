(* use_dsp = "yes" *) module subsubsquare_a_0_stage_signed_6_bit(
	input signed [5:0] a,
	input signed [5:0] c,
	input signed [5:0] d,
	output [5:0] out,
	input clk);

	assign out = c - ((d - a) * (d - a));
endmodule
