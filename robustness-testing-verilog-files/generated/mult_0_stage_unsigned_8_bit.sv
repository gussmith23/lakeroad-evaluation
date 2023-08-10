(* use_dsp = "yes" *) module mult_0_stage_unsigned_8_bit(
	input  [7:0] a,
	input  [7:0] b,
	output [7:0] out,
	input clk);

	assign out = a * b;
endmodule
