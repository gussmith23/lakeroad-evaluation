(* use_dsp = "yes" *) module addsquare_b_2_stage_unsigned_2_bit(
	input  [1:0] a,
	input  [1:0] d,
	output [1:0] out,
	input clk);

	logic  [3:0] stage0;
	logic  [3:0] stage1;

	always @(posedge clk) begin
	stage0 <= (d - a) * (d - a);
	stage1 <= stage0;
	end

	assign out = stage1;
endmodule
