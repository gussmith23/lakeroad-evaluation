(* use_dsp = "yes" *) module addmulxor_0_stage_unsigned_15_bit(
	input  [14:0] a,
	input  [14:0] b,
	input  [14:0] c,
	input  [14:0] d,
	output [14:0] out,
	input clk);

	assign out = ((d + a) * b) ^ c;
endmodule
