(* use_dsp = "yes" *) module addmulor_0_stage_unsigned_6_bit(
	input  [5:0] a,
	input  [5:0] b,
	input  [5:0] c,
	input  [5:0] d,
	output [5:0] out,
	input clk);

	assign out = ((d + a) * b) | c;
endmodule
