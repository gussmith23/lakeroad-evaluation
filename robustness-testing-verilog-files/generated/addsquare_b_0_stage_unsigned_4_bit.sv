(* use_dsp = "yes" *) module addsquare_b_0_stage_unsigned_4_bit(
	input  [3:0] a,
	input  [3:0] d,
	output [3:0] out,
	input clk);

	assign out = (d - a) * (d - a);
endmodule
