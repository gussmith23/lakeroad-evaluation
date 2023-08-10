(* use_dsp = "yes" *) module mult_0_stage_signed_16_bit(
	input signed [15:0] a,
	input signed [15:0] b,
	output [15:0] out,
	input clk);

	assign out = a * b;
endmodule
