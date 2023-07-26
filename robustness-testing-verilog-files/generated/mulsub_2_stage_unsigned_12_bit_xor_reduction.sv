(* use_dsp = "yes" *) module mulsub_2_stage_unsigned_12_bit_xor_reduction(
	input  [11:0] a,
	input  [11:0] b,
	input  [11:0] c,
	output [11:0] out,
	input clk);

	logic  [23:0] stage0;
	logic  [23:0] stage1;

	always @(posedge clk) begin
	stage0 <= (a * b) - c;
	stage1 <= stage0;
	end

	assign out = ^(stage1);
endmodule
