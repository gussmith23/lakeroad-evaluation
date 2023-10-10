(* use_dsp = "yes" *) module subsquare_b_0_stage_unsigned_5_bit(
	input  [4:0] b,
	input  [4:0] d,
	output [4:0] out,
	input clk);

	assign out = (d - b) * (d - b);
endmodule
