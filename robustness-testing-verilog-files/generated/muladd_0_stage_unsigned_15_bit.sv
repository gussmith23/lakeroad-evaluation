(* use_dsp = "yes" *) module muladd_0_stage_unsigned_15_bit(
	input  [14:0] a,
	input  [14:0] b,
	input  [14:0] c,
	output [14:0] out,
	input clk);

	assign out = (a * b) + c;
endmodule
