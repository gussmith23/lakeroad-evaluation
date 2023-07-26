(* use_dsp = "yes" *) module submulxor_1_stage_signed_14_bit_xor_reduction(
	input signed [13:0] a,
	input signed [13:0] b,
	input signed [13:0] c,
	input signed [13:0] d,
	output [13:0] out,
	input clk);

	logic signed [27:0] stage0;

	always @(posedge clk) begin
	stage0 <= ((d - a) * b) ^ c;

	end

	assign out = ^(stage0);
endmodule
