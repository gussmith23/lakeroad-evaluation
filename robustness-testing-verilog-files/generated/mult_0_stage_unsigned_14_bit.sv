(* use_dsp = "yes" *) module mult_0_stage_unsigned_14_bit(
	input  [13:0] a,
	input  [13:0] b,
	output [13:0] out,
	input clk);

	assign out = a * b;
endmodule
