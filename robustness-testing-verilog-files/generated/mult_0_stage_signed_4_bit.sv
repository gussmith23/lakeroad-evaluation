(* use_dsp = "yes" *) module mult_0_stage_signed_4_bit(
	input signed [3:0] a,
	input signed [3:0] b,
	output [3:0] out,
	input clk);

	assign out = a * b;
endmodule
