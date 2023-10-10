(* use_dsp = "yes" *) module mult_0_stage_unsigned_1_bit(
	input  [0:0] a,
	input  [0:0] b,
	output [0:0] out,
	input clk);

	assign out = a * b;
endmodule
