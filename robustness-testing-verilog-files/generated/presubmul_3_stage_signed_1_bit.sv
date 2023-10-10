(* use_dsp = "yes" *) module presubmul_3_stage_signed_1_bit(
	input signed [0:0] a,
	input signed [0:0] b,
	input signed [0:0] c,
	input signed [0:0] d,
	output [0:0] out,
	input clk);

	logic signed [1:0] stage0;
	logic signed [1:0] stage1;
	logic signed [1:0] stage2;

	always @(posedge clk) begin
	stage0 <= (d - a) * b;
	stage1 <= stage0;
	stage2 <= stage1;
	end

	assign out = stage2;
endmodule
