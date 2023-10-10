(* use_dsp = "yes" *) module mult_0_stage_signed_2_bit(
	input signed [1:0] a,
	input signed [1:0] b,
	output [1:0] out,
	input clk);

	assign out = a * b;
endmodule
