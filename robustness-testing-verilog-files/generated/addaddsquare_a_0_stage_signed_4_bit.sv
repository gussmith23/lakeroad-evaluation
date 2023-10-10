(* use_dsp = "yes" *) module addaddsquare_a_0_stage_signed_4_bit(
	input signed [3:0] a,
	input signed [3:0] c,
	input signed [3:0] d,
	output [3:0] out,
	input clk);

	assign out = c + ((d + a) * (d + a));
endmodule
