(* use_dsp = "yes" *) module mulxor_0_stage_signed_4_bit(
	input signed [3:0] a,
	input signed [3:0] b,
	input signed [3:0] c,
	output [3:0] out,
	input clk);

	assign out = (a * b) ^ c;
endmodule
