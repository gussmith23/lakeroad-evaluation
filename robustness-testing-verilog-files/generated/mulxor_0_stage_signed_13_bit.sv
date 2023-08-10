(* use_dsp = "yes" *) module mulxor_0_stage_signed_13_bit(
	input signed [12:0] a,
	input signed [12:0] b,
	input signed [12:0] c,
	output [12:0] out,
	input clk);

	assign out = (a * b) ^ c;
endmodule
