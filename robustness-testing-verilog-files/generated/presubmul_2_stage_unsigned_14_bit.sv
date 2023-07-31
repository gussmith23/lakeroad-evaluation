(* use_dsp = "yes" *) module presubmul_2_stage_unsigned_14_bit(
	input  [13:0] a,
	input  [13:0] b,
	input  [13:0] c,
	input  [13:0] d,
	output [13:0] out,
	input clk);

	logic  [27:0] stage0;
	logic  [27:0] stage1;

	always @(posedge clk) begin
	stage0 <= (d - a) * b;
	stage1 <= stage0;
	end

	assign out = stage1;
endmodule
