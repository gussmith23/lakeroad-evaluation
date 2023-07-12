(* use_dsp = "yes" *) module mult_2_stage_signed_15_bit(
	input signed [14:0] a,
	input signed [14:0] b,
	output [14:0] out,
	input clk);

	logic signed [29:0] stage0;
	logic signed [29:0] stage1;

	always @(posedge clk) begin
	stage0 <= a * b;
	stage1 <= stage0;
	end

	assign out = stage1;
endmodule
