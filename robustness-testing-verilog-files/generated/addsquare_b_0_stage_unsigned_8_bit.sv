(* use_dsp = "yes" *) module addsquare_b_0_stage_unsigned_8_bit(
	input  [7:0] a,
	input  [7:0] d,
	output [7:0] out,
	input clk);

	assign out = (d - a) * (d - a);
endmodule
