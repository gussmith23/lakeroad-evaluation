(* use_dsp = "yes" *) module mulxor_0_stage_signed_16_bit(
	input signed [15:0] a,
	input signed [15:0] b,
	input signed [15:0] c,
	output [15:0] out,
	input clk);

	assign out = (a * b) ^ c;
endmodule
