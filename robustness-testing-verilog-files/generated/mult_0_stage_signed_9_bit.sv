(* use_dsp = "yes" *) module mult_0_stage_signed_9_bit(
	input signed [8:0] a,
	input signed [8:0] b,
	output [8:0] out,
	input clk);

	assign out = a * b;
endmodule
