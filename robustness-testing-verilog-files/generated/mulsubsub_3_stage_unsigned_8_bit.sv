(* use_dsp = "yes" *) module mulsubsub_3_stage_unsigned_8_bit(
	input  [7:0] a,
	input  [7:0] b,
	input  [7:0] c,
	input  [7:0] d,
	output [7:0] out,
	input clk);

	logic  [15:0] stage0;
	logic  [15:0] stage1;
	logic  [15:0] stage2;

	always @(posedge clk) begin
	stage0 <= (a * b) - (c - d);
	stage1 <= stage0;
	stage2 <= stage1;
	end

	assign out = stage2;
endmodule
