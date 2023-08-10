(* use_dsp = "yes" *) module submulxor_0_stage_signed_11_bit(
	input signed [10:0] a,
	input signed [10:0] b,
	input signed [10:0] c,
	input signed [10:0] d,
	output [10:0] out,
	input clk);

	assign out = ((d - a) * b) ^ c;
endmodule
