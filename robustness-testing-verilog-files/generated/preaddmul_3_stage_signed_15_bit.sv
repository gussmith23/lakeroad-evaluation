(* use_dsp = "yes" *) module preaddmul_3_stage_signed_15_bit(
	input signed [14:0] d,
	input signed [14:0] a,
	input signed [14:0] b,
	output [14:0] out,
	input clk);

	logic signed [29:0] stage0;
	logic signed [29:0] stage1;
	logic signed [29:0] stage2;

	always @(posedge clk) begin
	stage0 <= (d + a) * b;
	stage1 <= stage0;
	stage2 <= stage1;
	end

	assign out = stage2;
endmodule
