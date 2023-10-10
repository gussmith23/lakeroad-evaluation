(* use_dsp = "yes" *) module mulor_0_stage_unsigned_3_bit(
	input  [2:0] a,
	input  [2:0] b,
	input  [2:0] c,
	output [2:0] out,
	input clk);

	assign out = (a * b) | c;
endmodule
