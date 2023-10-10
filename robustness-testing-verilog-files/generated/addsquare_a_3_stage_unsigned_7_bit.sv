(* use_dsp = "yes" *) module addsquare_a_3_stage_unsigned_7_bit(
	input  [6:0] a,
	input  [6:0] d,
	output [6:0] out,
	input clk);

	logic  [13:0] stage0;
	logic  [13:0] stage1;
	logic  [13:0] stage2;

	always @(posedge clk) begin
	stage0 <= (d + a) * (d + a);
	stage1 <= stage0;
	stage2 <= stage1;
	end

	assign out = stage2;
endmodule
