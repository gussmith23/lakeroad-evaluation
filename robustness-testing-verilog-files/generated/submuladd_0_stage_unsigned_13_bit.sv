(* use_dsp = "yes" *) module submuladd_0_stage_unsigned_13_bit(
	input  [12:0] a,
	input  [12:0] b,
	input  [12:0] c,
	input  [12:0] d,
	output [12:0] out,
	input clk);

	assign out = ((d - a) * b) + c;
endmodule
