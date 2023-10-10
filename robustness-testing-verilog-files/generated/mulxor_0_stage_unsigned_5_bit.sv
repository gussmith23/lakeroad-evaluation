(* use_dsp = "yes" *) module mulxor_0_stage_unsigned_5_bit(
	input  [4:0] a,
	input  [4:0] b,
	input  [4:0] c,
	output [4:0] out,
	input clk);

	assign out = (a * b) ^ c;
endmodule
