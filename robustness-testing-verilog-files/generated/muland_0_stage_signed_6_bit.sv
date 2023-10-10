(* use_dsp = "yes" *) module muland_0_stage_signed_6_bit(
	input signed [5:0] a,
	input signed [5:0] b,
	input signed [5:0] c,
	output [5:0] out,
	input clk);

	assign out = (a * b) & c;
endmodule
