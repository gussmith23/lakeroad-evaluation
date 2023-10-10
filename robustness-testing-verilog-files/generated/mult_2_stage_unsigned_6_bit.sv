(* use_dsp = "yes" *) module mult_2_stage_unsigned_6_bit(
	input  [5:0] a,
	input  [5:0] b,
	output [5:0] out,
	input clk);

	logic  [11:0] stage0;
	logic  [11:0] stage1;

	always @(posedge clk) begin
	stage0 <= a * b;
	stage1 <= stage0;
	end

	assign out = stage1;
endmodule
