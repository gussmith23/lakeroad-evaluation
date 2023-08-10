(* use_dsp = "yes" *) module mulsub_0_stage_signed_18_bit(
	input signed [17:0] a,
	input signed [17:0] b,
	input signed [17:0] c,
	output [17:0] out,
	input clk);

	assign out = (a * b) - c;
endmodule
