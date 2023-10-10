(* use_dsp = "yes" *) module mulor_0_stage_unsigned_4_bit(
	input  [3:0] a,
	input  [3:0] b,
	input  [3:0] c,
	output [3:0] out,
	input clk);

	assign out = (a * b) | c;
endmodule
