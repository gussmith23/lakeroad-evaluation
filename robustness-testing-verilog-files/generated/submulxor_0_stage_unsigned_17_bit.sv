(* use_dsp = "yes" *) module submulxor_0_stage_unsigned_17_bit(
	input  [16:0] a,
	input  [16:0] b,
	input  [16:0] c,
	input  [16:0] d,
	output [16:0] out,
	input clk);

	assign out = ((d - a) * b) ^ c;
endmodule
