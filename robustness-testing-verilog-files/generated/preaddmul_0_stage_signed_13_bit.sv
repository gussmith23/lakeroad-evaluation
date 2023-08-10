(* use_dsp = "yes" *) module preaddmul_0_stage_signed_13_bit(
	input signed [12:0] d,
	input signed [12:0] a,
	input signed [12:0] b,
	output [12:0] out,
	input clk);

	assign out = (d + a) * b;
endmodule
