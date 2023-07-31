(* use_dsp = "yes" *) module mult_1_stage_signed_13_bit_xor_reduction(
	input signed [12:0] a,
	input signed [12:0] b,
	output [12:0] out,
	input clk);

	logic signed [25:0] stage0;

	always @(posedge clk) begin
	stage0 <= a * b;

	end

	assign out = ^(stage0);
endmodule
