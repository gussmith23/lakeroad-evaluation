(* use_dsp = "yes" *) module preaddmul_0_stage_signed_5_bit(
	input signed [4:0] a,
	input signed [4:0] b,
	input signed [4:0] d,
	output [4:0] out,
	input clk);

	assign out = (d + a) * b;
endmodule
