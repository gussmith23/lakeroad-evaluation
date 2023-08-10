(* use_dsp = "yes" *) module mulsub_0_stage_signed_11_bit(
	input signed [10:0] a,
	input signed [10:0] b,
	input signed [10:0] c,
	output [10:0] out,
	input clk);

	assign out = (a * b) - c;
endmodule
