(* use_dsp = "yes" *) module mult_0_stage_signed_5_bit(
	input signed [4:0] a,
	input signed [4:0] b,
	output [4:0] out,
	input clk);

	assign out = a * b;
endmodule
