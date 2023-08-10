(* use_dsp = "yes" *) module mulor_0_stage_unsigned_10_bit(
	input  [9:0] a,
	input  [9:0] b,
	input  [9:0] c,
	output [9:0] out,
	input clk);

	assign out = (a * b) | c;
endmodule
