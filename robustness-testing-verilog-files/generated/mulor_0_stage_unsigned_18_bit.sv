(* use_dsp = "yes" *) module mulor_0_stage_unsigned_18_bit(
	input  [17:0] a,
	input  [17:0] b,
	input  [17:0] c,
	output [17:0] out,
	input clk);

	assign out = (a * b) | c;
endmodule
