(* use_dsp = "yes" *) module preaddmul_0_stage_signed_12_bit(
	input signed [11:0] d,
	input signed [11:0] a,
	input signed [11:0] b,
	output [11:0] out,
	input clk);

	assign out = (d + a) * b;
endmodule
