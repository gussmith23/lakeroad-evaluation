(* use_dsp = "yes" *) module subsubsquare_b_0_stage_signed_5_bit(
	input signed [4:0] b,
	input signed [4:0] c,
	input signed [4:0] d,
	output [4:0] out,
	input clk);

	assign out = c - ((d - b) * (d - b));
endmodule
