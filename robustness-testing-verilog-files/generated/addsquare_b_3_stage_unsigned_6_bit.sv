(* use_dsp = "yes" *) module addsquare_b_3_stage_unsigned_6_bit(
	input  [5:0] a,
	input  [5:0] d,
	output [5:0] out,
	input clk);

	logic  [11:0] stage0;
	logic  [11:0] stage1;
	logic  [11:0] stage2;

	always @(posedge clk) begin
	stage0 <= (d - a) * (d - a);
	stage1 <= stage0;
	stage2 <= stage1;
	end

	assign out = stage2;
endmodule
