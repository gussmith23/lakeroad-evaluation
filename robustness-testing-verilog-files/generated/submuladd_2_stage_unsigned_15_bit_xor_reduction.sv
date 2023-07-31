(* use_dsp = "yes" *) module submuladd_2_stage_unsigned_15_bit_xor_reduction(
	input  [14:0] a,
	input  [14:0] b,
	input  [14:0] c,
	input  [14:0] d,
	output [14:0] out,
	input clk);

	logic  [29:0] stage0;
	logic  [29:0] stage1;

	always @(posedge clk) begin
	stage0 <= ((d - a) * b) + c;
	stage1 <= stage0;
	end

	assign out = ^(stage1);
endmodule
