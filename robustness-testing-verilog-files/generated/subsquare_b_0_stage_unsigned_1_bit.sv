(* use_dsp = "yes" *) module subsquare_b_0_stage_unsigned_1_bit(
	input  [0:0] b,
	input  [0:0] d,
	output [0:0] out,
	input clk);

	assign out = (d - b) * (d - b);
endmodule
