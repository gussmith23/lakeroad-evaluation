(* use_dsp = "yes" *) module submuland_0_stage_signed_13_bit(
	input signed [12:0] a,
	input signed [12:0] b,
	input signed [12:0] c,
	input signed [12:0] d,
	output [12:0] out,
	input clk);

	assign out = ((d - a) * b) & c;
endmodule
