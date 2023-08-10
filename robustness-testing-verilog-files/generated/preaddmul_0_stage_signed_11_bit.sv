(* use_dsp = "yes" *) module preaddmul_0_stage_signed_11_bit(
	input signed [10:0] d,
	input signed [10:0] a,
	input signed [10:0] b,
	output [10:0] out,
	input clk);

	assign out = (d + a) * b;
endmodule
