(* use_dsp = "yes" *) module mult_0_stage_unsigned_12_bit(
	input  [11:0] a,
	input  [11:0] b,
	output [11:0] out,
	input clk);

	assign out = a * b;
endmodule
