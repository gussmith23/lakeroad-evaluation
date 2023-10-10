(* use_dsp = "yes" *) module mulsub_0_stage_signed_2_bit(
	input signed [1:0] a,
	input signed [1:0] b,
	input signed [1:0] c,
	output [1:0] out,
	input clk);

	assign out = (a * b) - c;
endmodule
