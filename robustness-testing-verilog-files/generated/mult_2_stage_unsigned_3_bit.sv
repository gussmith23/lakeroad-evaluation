(* use_dsp = "yes" *) module mult_2_stage_unsigned_3_bit(
	input  [2:0] a,
	input  [2:0] b,
	output [2:0] out,
	input clk);

	logic  [5:0] stage0;
	logic  [5:0] stage1;

	always @(posedge clk) begin
	stage0 <= a * b;
	stage1 <= stage0;
	end

	assign out = stage1;
endmodule
