(* use_dsp = "yes" *) module addmuland_0_stage_unsigned_5_bit(
	input  [4:0] a,
	input  [4:0] b,
	input  [4:0] c,
	input  [4:0] d,
	output [4:0] out,
	input clk);

	assign out = ((d + a) * b) & c;
endmodule
