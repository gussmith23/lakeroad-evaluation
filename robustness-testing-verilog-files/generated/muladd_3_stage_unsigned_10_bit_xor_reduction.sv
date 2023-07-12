(* use_dsp = "yes" *) module muladd_3_stage_unsigned_10_bit_xor_reduction(
	input  [9:0] a,
	input  [9:0] b,
	input  [9:0] c,
	output [9:0] out,
	input clk);

	logic  [19:0] stage0;
	logic  [19:0] stage1;
	logic  [19:0] stage2;

	always @(posedge clk) begin
	stage0 <= (a * b) + c;
	stage1 <= stage0;
	stage2 <= stage1;
	end

	assign out = ^(stage2);
endmodule
