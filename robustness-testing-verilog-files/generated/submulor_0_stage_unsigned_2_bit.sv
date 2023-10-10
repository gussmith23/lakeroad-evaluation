(* use_dsp = "yes" *) module submulor_0_stage_unsigned_2_bit(
	input  [1:0] a,
	input  [1:0] b,
	input  [1:0] c,
	input  [1:0] d,
	output [1:0] out,
	input clk);

	assign out = ((d - a) * b) | c;
endmodule
