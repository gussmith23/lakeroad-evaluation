(* use_dsp = "yes" *) module mulor_0_stage_unsigned_1_bit(
	input  [0:0] a,
	input  [0:0] b,
	input  [0:0] c,
	output [0:0] out,
	input clk);

	assign out = (a * b) | c;
endmodule
