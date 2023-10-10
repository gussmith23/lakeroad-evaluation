(* use_dsp = "yes" *) module mult_0_stage_signed_1_bit(
	input signed [0:0] a,
	input signed [0:0] b,
	output signed [0:0] out,
	input clk);

	assign out = a * b;
endmodule
