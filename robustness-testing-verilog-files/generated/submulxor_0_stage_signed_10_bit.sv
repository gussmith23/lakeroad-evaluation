(* use_dsp = "yes" *) module submulxor_0_stage_signed_10_bit(
	input signed [9:0] a,
	input signed [9:0] b,
	input signed [9:0] c,
	input signed [9:0] d,
	output [9:0] out,
	input clk);

	assign out = ((d - a) * b) ^ c;
endmodule
