(* use_dsp = "yes" *) module subsubsquare_b_2_stage_unsigned_5_bit(
	input  [4:0] b,
	input  [4:0] c,
	input  [4:0] d,
	output [4:0] out,
	input clk);

	logic  [9:0] stage0;
	logic  [9:0] stage1;

	always @(posedge clk) begin
	stage0 <= c - ((d - b) * (d - b));
	stage1 <= stage0;
	end

	assign out = stage1;
endmodule
