(* use_dsp = "yes" *) module mult_0_stage_unsigned_7_bit(
	input  [6:0] a,
	input  [6:0] b,
	output [6:0] out,
	input clk);

	assign out = a * b;
endmodule
