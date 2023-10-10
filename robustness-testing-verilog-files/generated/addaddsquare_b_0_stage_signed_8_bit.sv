(* use_dsp = "yes" *) module addaddsquare_b_0_stage_signed_8_bit(
	input signed [7:0] b,
	input signed [7:0] c,
	input signed [7:0] d,
	output [7:0] out,
	input clk);

	assign out = c + ((d + b) * (d + b));
endmodule
