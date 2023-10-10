(* use_dsp = "yes" *) module muland_3_stage_unsigned_1_bit(
	input  [0:0] a,
	input  [0:0] b,
	input  [0:0] c,
	output [0:0] out,
	input clk);

	logic  [1:0] stage0;
	logic  [1:0] stage1;
	logic  [1:0] stage2;

	always @(posedge clk) begin
	stage0 <= (a * b) & c;
	stage1 <= stage0;
	stage2 <= stage1;
	end

	assign out = stage2;
endmodule
