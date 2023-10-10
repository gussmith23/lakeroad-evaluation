(* use_dsp = "yes" *) module addmulsub_0_stage_signed_3_bit(
	input signed [2:0] a,
	input signed [2:0] b,
	input signed [2:0] c,
	input signed [2:0] d,
	output [2:0] out,
	input clk);

	assign out = ((d + a) * b) - c;
endmodule
