(* use_dsp = "yes" *) module submulor_0_stage_unsigned_9_bit(
	input  [8:0] a,
	input  [8:0] b,
	input  [8:0] c,
	input  [8:0] d,
	output [8:0] out,
	input clk);

	assign out = ((d - a) * b) | c;
endmodule
