(* use_dsp = "yes" *) module mult_0_stage_unsigned_6_bit(
	input  [5:0] a,
	input  [5:0] b,
	output [5:0] out,
	input clk);

	assign out = a * b;
endmodule
