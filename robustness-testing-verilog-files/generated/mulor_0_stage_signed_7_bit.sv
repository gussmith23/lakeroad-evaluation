(* use_dsp = "yes" *) module mulor_0_stage_signed_7_bit(
	input signed [6:0] a,
	input signed [6:0] b,
	input signed [6:0] c,
	output [6:0] out,
	input clk);

	assign out = (a * b) | c;
endmodule
