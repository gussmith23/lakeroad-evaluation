(* use_dsp = "yes" *) module subaddsquare_a_3_stage_unsigned_2_bit(
	input  [1:0] a,
	input  [1:0] c,
	input  [1:0] d,
	output [1:0] out,
	input clk);

	logic  [3:0] stage0;
	logic  [3:0] stage1;
	logic  [3:0] stage2;

	always @(posedge clk) begin
	stage0 <= c - ((d + a) * (d + a));
	stage1 <= stage0;
	stage2 <= stage1;
	end

	assign out = stage2;
endmodule
