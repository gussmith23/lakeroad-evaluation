(* use_dsp = "yes" *) module addaddsquare_b_0_stage_unsigned_4_bit(
	input  [3:0] b,
	input  [3:0] c,
	input  [3:0] d,
	output [3:0] out,
	input clk);

	assign out = c + ((d + b) * (d + b));
endmodule
