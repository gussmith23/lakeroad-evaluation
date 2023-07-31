(* use_dsp = "yes" *) module mulsubsub_2_stage_unsigned_16_bit(
	input  [15:0] a,
	input  [15:0] b,
	input  [15:0] c,
	input  [15:0] d,
	output [15:0] out,
	input clk);

	logic  [31:0] stage0;
	logic  [31:0] stage1;

	always @(posedge clk) begin
	stage0 <= (a * b) - (c - d);
	stage1 <= stage0;
	end

	assign out = stage1;
endmodule
