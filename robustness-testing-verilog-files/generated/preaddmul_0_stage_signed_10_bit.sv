(* use_dsp = "yes" *) module preaddmul_0_stage_signed_10_bit(
	input signed [9:0] d,
	input signed [9:0] a,
	input signed [9:0] b,
	output [9:0] out,
	input clk);

	assign out = (d + a) * b;
endmodule
