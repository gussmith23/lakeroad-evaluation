(* use_dsp = "yes" *) module mult_3_stage_unsigned_13_bit(
	input  [12:0] a,
	input  [12:0] b,
	output [12:0] out,
	input clk);

	logic  [25:0] stage0;
	logic  [25:0] stage1;
	logic  [25:0] stage2;

	always @(posedge clk) begin
	stage0 <= a * b;
	stage1 <= stage0;
	stage2 <= stage1;
	end

	assign out = stage2;
endmodule
