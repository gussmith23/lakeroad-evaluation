(* use_dsp = "yes" *) module presubmul_3_stage_signed_3_bit(
	input signed [2:0] a,
	input signed [2:0] b,
	input signed [2:0] c,
	input signed [2:0] d,
	output [2:0] out,
	input clk);

	logic signed [5:0] stage0;
	logic signed [5:0] stage1;
	logic signed [5:0] stage2;

	always @(posedge clk) begin
	stage0 <= (d - a) * b;
	stage1 <= stage0;
	stage2 <= stage1;
	end

	assign out = stage2;
endmodule
