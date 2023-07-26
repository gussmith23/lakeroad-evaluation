(* use_dsp = "yes" *) module mulsub_3_stage_unsigned_9_bit_xor_reduction(
	input  [8:0] a,
	input  [8:0] b,
	input  [8:0] c,
	output [8:0] out,
	input clk);

	logic  [17:0] stage0;
	logic  [17:0] stage1;
	logic  [17:0] stage2;

	always @(posedge clk) begin
	stage0 <= (a * b) - c;
	stage1 <= stage0;
	stage2 <= stage1;
	end

	assign out = ^(stage2);
endmodule
