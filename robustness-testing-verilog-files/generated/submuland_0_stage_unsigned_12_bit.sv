(* use_dsp = "yes" *) module submuland_0_stage_unsigned_12_bit(
	input  [11:0] a,
	input  [11:0] b,
	input  [11:0] c,
	input  [11:0] d,
	output [11:0] out,
	input clk);

	assign out = ((d - a) * b) & c;
endmodule
