(* use_dsp = "yes" *) module mult_0_stage_signed_6_bit(
	input signed [5:0] a,
	input signed [5:0] b,
	output [5:0] out,
	input clk);

	assign out = a * b;
endmodule
