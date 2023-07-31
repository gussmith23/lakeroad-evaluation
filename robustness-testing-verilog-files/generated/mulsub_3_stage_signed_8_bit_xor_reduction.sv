(* use_dsp = "yes" *) module mulsub_3_stage_signed_8_bit_xor_reduction(
	input signed [7:0] a,
	input signed [7:0] b,
	input signed [7:0] c,
	output [7:0] out,
	input clk);

	logic signed [15:0] stage0;
	logic signed [15:0] stage1;
	logic signed [15:0] stage2;

	always @(posedge clk) begin
	stage0 <= (a * b) - c;
	stage1 <= stage0;
	stage2 <= stage1;
	end

	assign out = ^(stage2);
endmodule
