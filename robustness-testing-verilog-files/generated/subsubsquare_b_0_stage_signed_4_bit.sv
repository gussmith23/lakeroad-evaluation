(* use_dsp = "yes" *) module subsubsquare_b_0_stage_signed_4_bit(
	input signed [3:0] b,
	input signed [3:0] c,
	input signed [3:0] d,
	output [3:0] out,
	input clk);

	assign out = c - ((d - b) * (d - b));
endmodule
