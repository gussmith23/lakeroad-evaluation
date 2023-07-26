(* use_dsp = "yes" *) module mulsub_3_stage_unsigned_14_bit(
	input  [13:0] a,
	input  [13:0] b,
	input  [13:0] c,
	output [13:0] out,
	input clk);

	logic  [27:0] stage0;
	logic  [27:0] stage1;
	logic  [27:0] stage2;

	always @(posedge clk) begin
	stage0 <= (a * b) - c;
	stage1 <= stage0;
	stage2 <= stage1;
	end

	assign out = stage2;
endmodule
