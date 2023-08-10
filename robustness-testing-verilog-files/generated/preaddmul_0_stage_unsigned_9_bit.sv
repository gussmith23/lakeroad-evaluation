(* use_dsp = "yes" *) module preaddmul_0_stage_unsigned_9_bit(
	input  [8:0] d,
	input  [8:0] a,
	input  [8:0] b,
	output [8:0] out,
	input clk);

	assign out = (d + a) * b;
endmodule
