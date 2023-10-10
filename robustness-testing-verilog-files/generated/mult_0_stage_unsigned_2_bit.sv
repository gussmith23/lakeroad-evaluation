(* use_dsp = "yes" *) module mult_0_stage_unsigned_2_bit(
	input  [1:0] a,
	input  [1:0] b,
	output [1:0] out,
	input clk);

	assign out = a * b;
endmodule
