(* use_dsp = "yes" *) module mulor_0_stage_signed_5_bit(
	input signed [4:0] a,
	input signed [4:0] b,
	input signed [4:0] c,
	output [4:0] out,
	input clk);

	assign out = (a * b) | c;
endmodule
