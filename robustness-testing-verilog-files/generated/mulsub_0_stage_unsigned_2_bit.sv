(* use_dsp = "yes" *) module mulsub_0_stage_unsigned_2_bit(
	input  [1:0] a,
	input  [1:0] b,
	input  [1:0] c,
	output [1:0] out,
	input clk);

	assign out = (a * b) - c;
endmodule
