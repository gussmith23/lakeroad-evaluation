(* use_dsp = "yes" *) module submuland_0_stage_unsigned_7_bit(
	input  [6:0] a,
	input  [6:0] b,
	input  [6:0] c,
	input  [6:0] d,
	output [6:0] out,
	input clk);

	assign out = ((d - a) * b) & c;
endmodule
