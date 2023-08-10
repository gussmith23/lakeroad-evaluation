(* use_dsp = "yes" *) module addmulor_0_stage_unsigned_18_bit(
	input  [17:0] a,
	input  [17:0] b,
	input  [17:0] c,
	input  [17:0] d,
	output [17:0] out,
	input clk);

	assign out = ((d + a) * b) | c;
endmodule
