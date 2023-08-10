(* use_dsp = "yes" *) module mult_0_stage_unsigned_10_bit(
	input  [9:0] a,
	input  [9:0] b,
	output [9:0] out,
	input clk);

	assign out = a * b;
endmodule
