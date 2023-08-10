(* use_dsp = "yes" *) module mulxor_0_stage_unsigned_14_bit(
	input  [13:0] a,
	input  [13:0] b,
	input  [13:0] c,
	output [13:0] out,
	input clk);

	assign out = (a * b) ^ c;
endmodule
