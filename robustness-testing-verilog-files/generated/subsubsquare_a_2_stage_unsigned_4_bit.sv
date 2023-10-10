(* use_dsp = "yes" *) module subsubsquare_a_2_stage_unsigned_4_bit(
	input  [3:0] a,
	input  [3:0] c,
	input  [3:0] d,
	output [3:0] out,
	input clk);

	logic  [7:0] stage0;
	logic  [7:0] stage1;

	always @(posedge clk) begin
	stage0 <= c - ((d - a) * (d - a));
	stage1 <= stage0;
	end

	assign out = stage1;
endmodule
