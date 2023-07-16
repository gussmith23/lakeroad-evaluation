(* use_dsp = "yes" *) module mulor_2_stage_unsigned_10_bit(
	input  [9:0] a,
	input  [9:0] b,
	input  [9:0] c,
	output [9:0] out,
	input clk);

	logic  [19:0] stage0;
	logic  [19:0] stage1;

	always @(posedge clk) begin
	stage0 <= (a * b) | c;
	stage1 <= stage0;
	end

	assign out = stage1;
endmodule
