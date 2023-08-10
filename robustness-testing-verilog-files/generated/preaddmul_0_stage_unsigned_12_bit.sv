(* use_dsp = "yes" *) module preaddmul_0_stage_unsigned_12_bit(
	input  [11:0] d,
	input  [11:0] a,
	input  [11:0] b,
	output [11:0] out,
	input clk);

	assign out = (d + a) * b;
endmodule
