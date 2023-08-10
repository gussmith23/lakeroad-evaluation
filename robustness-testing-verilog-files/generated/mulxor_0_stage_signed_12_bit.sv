(* use_dsp = "yes" *) module mulxor_0_stage_signed_12_bit(
	input signed [11:0] a,
	input signed [11:0] b,
	input signed [11:0] c,
	output [11:0] out,
	input clk);

	assign out = (a * b) ^ c;
endmodule
