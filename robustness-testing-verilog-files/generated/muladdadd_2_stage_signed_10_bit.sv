(* use_dsp = "yes" *) module muladdadd_2_stage_signed_10_bit(
	input signed [9:0] a,
	input signed [9:0] b,
	input signed [9:0] c,
	input signed [9:0] d,
	output [9:0] out,
	input clk);

	logic signed [19:0] stage0;
	logic signed [19:0] stage1;

	always @(posedge clk) begin
	stage0 <= (a * b) + (c + d);
	stage1 <= stage0;
	end

	assign out = stage1;
endmodule
