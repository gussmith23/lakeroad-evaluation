(* use_dsp = "yes" *) module preaddmul_0_stage_unsigned_18_bit(
	input  [17:0] d,
	input  [17:0] a,
	input  [17:0] b,
	output [17:0] out,
	input clk);

	assign out = (d + a) * b;
endmodule
