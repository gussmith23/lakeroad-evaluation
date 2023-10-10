(* use_dsp = "yes" *) module subaddsquare_b_3_stage_unsigned_5_bit(
	input  [4:0] b,
	input  [4:0] c,
	input  [4:0] d,
	output [4:0] out,
	input clk);

	logic  [9:0] stage0;
	logic  [9:0] stage1;
	logic  [9:0] stage2;

	always @(posedge clk) begin
	stage0 <= c - ((d + b) * (d + b));
	stage1 <= stage0;
	stage2 <= stage1;
	end

	assign out = stage2;
endmodule
