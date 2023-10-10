(* use_dsp = "yes" *) module addmulxor_0_stage_signed_2_bit(
	input signed [1:0] a,
	input signed [1:0] b,
	input signed [1:0] c,
	input signed [1:0] d,
	output [1:0] out,
	input clk);

	assign out = ((d + a) * b) ^ c;
endmodule
