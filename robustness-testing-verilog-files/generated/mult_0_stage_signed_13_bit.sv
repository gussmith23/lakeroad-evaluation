(* use_dsp = "yes" *) module mult_0_stage_signed_13_bit(
	input signed [12:0] a,
	input signed [12:0] b,
	output [12:0] out,
	input clk);

	assign out = a * b;
endmodule
