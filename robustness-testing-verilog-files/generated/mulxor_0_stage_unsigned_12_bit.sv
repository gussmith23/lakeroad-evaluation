(* use_dsp = "yes" *) module mulxor_0_stage_unsigned_12_bit(
	input  [11:0] a,
	input  [11:0] b,
	input  [11:0] c,
	output [11:0] out,
	input clk);

	assign out = (a * b) ^ c;
endmodule
