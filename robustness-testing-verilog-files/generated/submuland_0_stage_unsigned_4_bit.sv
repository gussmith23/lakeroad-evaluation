(* use_dsp = "yes" *) module submuland_0_stage_unsigned_4_bit(
	input  [3:0] a,
	input  [3:0] b,
	input  [3:0] c,
	input  [3:0] d,
	output [3:0] out,
	input clk);

	assign out = ((d - a) * b) & c;
endmodule
