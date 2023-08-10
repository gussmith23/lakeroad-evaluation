(* use_dsp = "yes" *) module mult_0_stage_signed_8_bit(
	input signed [7:0] a,
	input signed [7:0] b,
	output [7:0] out,
	input clk);

	assign out = a * b;
endmodule
