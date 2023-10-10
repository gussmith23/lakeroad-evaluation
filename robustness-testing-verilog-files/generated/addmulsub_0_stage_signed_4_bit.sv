(* use_dsp = "yes" *) module addmulsub_0_stage_signed_4_bit(
	input signed [3:0] a,
	input signed [3:0] b,
	input signed [3:0] c,
	input signed [3:0] d,
	output [3:0] out,
	input clk);

	assign out = ((d + a) * b) - c;
endmodule
