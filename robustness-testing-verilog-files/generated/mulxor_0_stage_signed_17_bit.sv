(* use_dsp = "yes" *) module mulxor_0_stage_signed_17_bit(
	input signed [16:0] a,
	input signed [16:0] b,
	input signed [16:0] c,
	output [16:0] out,
	input clk);

	assign out = (a * b) ^ c;
endmodule
