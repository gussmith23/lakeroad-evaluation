(* use_dsp = "yes" *) module mulsubadd_2_stage_unsigned_17_bit(
	input  [16:0] a,
	input  [16:0] b,
	input  [16:0] c,
	input  [16:0] d,
	output [16:0] out,
	input clk);

	logic  [33:0] stage0;
	logic  [33:0] stage1;

	always @(posedge clk) begin
	stage0 <= (a * b) - (c + d);
	stage1 <= stage0;
	end

	assign out = stage1;
endmodule
