(* use_dsp = "yes" *) module subsquare_a_3_stage_unsigned_3_bit(
	input  [2:0] a,
	input  [2:0] d,
	output [2:0] out,
	input clk);

	logic  [5:0] stage0;
	logic  [5:0] stage1;
	logic  [5:0] stage2;

	always @(posedge clk) begin
	stage0 <= (d - a) * (d - a);
	stage1 <= stage0;
	stage2 <= stage1;
	end

	assign out = stage2;
endmodule
