(* use_dsp = "yes" *) module preaddmul_0_stage_unsigned_17_bit(
	input  [16:0] d,
	input  [16:0] a,
	input  [16:0] b,
	output [16:0] out,
	input clk);

	assign out = (d + a) * b;
endmodule
