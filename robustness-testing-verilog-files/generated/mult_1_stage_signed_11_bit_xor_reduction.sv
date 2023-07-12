(* use_dsp = "yes" *) module mult_1_stage_signed_11_bit_xor_reduction(
	input signed [10:0] a,
	input signed [10:0] b,
	output [10:0] out,
	input clk);

	logic signed [21:0] stage0;

	always @(posedge clk) begin
	stage0 <= a * b;

	end

	assign out = ^(stage0);
endmodule
