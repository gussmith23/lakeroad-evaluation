(* use_dsp = "yes" *) module subaddsquare_a_3_stage_signed_4_bit(
	input signed [3:0] a,
	input signed [3:0] c,
	input signed [3:0] d,
	output [3:0] out,
	input clk);

	logic signed [7:0] stage0;
	logic signed [7:0] stage1;
	logic signed [7:0] stage2;

	always @(posedge clk) begin
	stage0 <= c - ((d + a) * (d + a));
	stage1 <= stage0;
	stage2 <= stage1;
	end

	assign out = stage2;
endmodule
