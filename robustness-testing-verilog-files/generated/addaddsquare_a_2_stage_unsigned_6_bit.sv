(* use_dsp = "yes" *) module addaddsquare_a_2_stage_unsigned_6_bit(
	input  [5:0] a,
	input  [5:0] c,
	input  [5:0] d,
	output [5:0] out,
	input clk);

	logic  [11:0] stage0;
	logic  [11:0] stage1;

	always @(posedge clk) begin
	stage0 <= c + ((d + a) * (d + a));
	stage1 <= stage0;
	end

	assign out = stage1;
endmodule
