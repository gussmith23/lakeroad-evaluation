(* use_dsp = "yes" *) module muland_0_stage_signed_15_bit(
	input signed [14:0] a,
	input signed [14:0] b,
	input signed [14:0] c,
	output [14:0] out,
	input clk);

	assign out = (a * b) & c;
endmodule
