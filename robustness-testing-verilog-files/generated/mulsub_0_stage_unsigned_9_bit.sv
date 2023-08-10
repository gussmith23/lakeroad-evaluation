(* use_dsp = "yes" *) module mulsub_0_stage_unsigned_9_bit(
	input  [8:0] a,
	input  [8:0] b,
	input  [8:0] c,
	output [8:0] out,
	input clk);

	assign out = (a * b) - c;
endmodule
