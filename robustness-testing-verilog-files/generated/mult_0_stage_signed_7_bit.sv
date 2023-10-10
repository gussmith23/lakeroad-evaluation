(* use_dsp = "yes" *) module mult_0_stage_signed_7_bit(
	input signed [6:0] a,
	input signed [6:0] b,
	output [6:0] out,
	input clk);

	assign out = a * b;
endmodule
