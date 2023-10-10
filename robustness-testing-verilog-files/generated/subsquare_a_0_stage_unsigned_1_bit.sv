(* use_dsp = "yes" *) module subsquare_a_0_stage_unsigned_1_bit(
	input  [0:0] a,
	input  [0:0] d,
	output [0:0] out,
	input clk);

	assign out = (d - a) * (d - a);
endmodule
