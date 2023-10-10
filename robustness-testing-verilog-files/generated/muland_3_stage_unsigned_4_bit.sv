(* use_dsp = "yes" *) module muland_3_stage_unsigned_4_bit(
	input  [3:0] a,
	input  [3:0] b,
	input  [3:0] c,
	output [3:0] out,
	input clk);

	logic  [7:0] stage0;
	logic  [7:0] stage1;
	logic  [7:0] stage2;

	always @(posedge clk) begin
	stage0 <= (a * b) & c;
	stage1 <= stage0;
	stage2 <= stage1;
	end

	assign out = stage2;
endmodule
