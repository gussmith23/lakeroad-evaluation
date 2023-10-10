(* use_dsp = "yes" *) module submuladd_0_stage_signed_1_bit(
	input signed [0:0] a,
	input signed [0:0] b,
	input signed [0:0] c,
	input signed [0:0] d,
	output [0:0] out,
	input clk);

	assign out = ((d - a) * b) + c;
endmodule
