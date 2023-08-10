(* use_dsp = "yes" *) module preaddmul_0_stage_signed_14_bit(
	input signed [13:0] a,
	input signed [13:0] b,
	input signed [13:0] d,
	output [13:0] out,
	input clk);

	assign out = (d + a) * b;
endmodule
