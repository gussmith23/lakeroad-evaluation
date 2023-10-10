(* use_dsp = "yes" *) module addaddsquare_a_2_stage_unsigned_1_bit(
	input  [0:0] a,
	input  [0:0] c,
	input  [0:0] d,
	output [0:0] out,
	input clk);

	logic  [1:0] stage0;
	logic  [1:0] stage1;

	always @(posedge clk) begin
	stage0 <= c + ((d + a) * (d + a));
	stage1 <= stage0;
	end

	assign out = stage1;
endmodule
