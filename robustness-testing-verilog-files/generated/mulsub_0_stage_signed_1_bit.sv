(* use_dsp = "yes" *) module mulsub_0_stage_signed_1_bit(
	input signed [0:0] a,
	input signed [0:0] b,
	input signed [0:0] c,
	output [0:0] out,
	input clk);

	assign out = (a * b) - c;
endmodule
