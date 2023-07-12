(* use_dsp = "yes" *) module preaddmul_2_stage_signed_10_bit_xor_reduction(
	input signed [9:0] d,
	input signed [9:0] a,
	input signed [9:0] b,
	output [9:0] out,
	input clk);

	logic signed [19:0] stage0;
	logic signed [19:0] stage1;

	always @(posedge clk) begin
	stage0 <= (d + a) * b;
	stage1 <= stage0;
	end

	assign out = ^(stage1);
endmodule
