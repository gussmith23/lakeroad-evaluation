(* use_dsp = "yes" *) module mulsub_0_stage_signed_8_bit(
	input signed [7:0] a,
	input signed [7:0] b,
	input signed [7:0] c,
	output [7:0] out,
	input clk);

	assign out = (a * b) - c;
endmodule
