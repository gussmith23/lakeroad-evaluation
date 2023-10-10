(* use_dsp = "yes" *) module muland_0_stage_unsigned_7_bit(
	input  [6:0] a,
	input  [6:0] b,
	input  [6:0] c,
	output [6:0] out,
	input clk);

	assign out = (a * b) & c;
endmodule
