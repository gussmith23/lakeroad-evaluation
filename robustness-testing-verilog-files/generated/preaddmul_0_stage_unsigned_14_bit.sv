(* use_dsp = "yes" *) module preaddmul_0_stage_unsigned_14_bit(
	input  [13:0] d,
	input  [13:0] a,
	input  [13:0] b,
	output [13:0] out,
	input clk);

	assign out = (d + a) * b;
endmodule
