(* use_dsp = "yes" *) module mult_0_stage_unsigned_4_bit(
	input  [3:0] a,
	input  [3:0] b,
	output [3:0] out,
	input clk);

	assign out = a * b;
endmodule
