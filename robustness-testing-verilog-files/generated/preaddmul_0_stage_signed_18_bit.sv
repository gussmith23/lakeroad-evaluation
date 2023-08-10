(* use_dsp = "yes" *) module preaddmul_0_stage_signed_18_bit(
	input signed [17:0] d,
	input signed [17:0] a,
	input signed [17:0] b,
	output [17:0] out,
	input clk);

	assign out = (d + a) * b;
endmodule
