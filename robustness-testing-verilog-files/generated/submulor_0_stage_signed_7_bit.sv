(* use_dsp = "yes" *) module submulor_0_stage_signed_7_bit(
	input signed [6:0] a,
	input signed [6:0] b,
	input signed [6:0] c,
	input signed [6:0] d,
	output [6:0] out,
	input clk);

	assign out = ((d - a) * b) | c;
endmodule
