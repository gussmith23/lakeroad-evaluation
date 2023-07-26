(* use_dsp = "yes" *) module submulsub_1_stage_signed_11_bit_xor_reduction(
	input signed [10:0] a,
	input signed [10:0] b,
	input signed [10:0] c,
	input signed [10:0] d,
	output [10:0] out,
	input clk);

	logic signed [21:0] stage0;

	always @(posedge clk) begin
	stage0 <= ((d - a) * b) - c;

	end

	assign out = ^(stage0);
endmodule
