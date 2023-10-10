(* use_dsp = "yes" *) module muland_0_stage_unsigned_6_bit(
	input  [5:0] a,
	input  [5:0] b,
	input  [5:0] c,
	output [5:0] out,
	input clk);

	assign out = (a * b) & c;
endmodule
