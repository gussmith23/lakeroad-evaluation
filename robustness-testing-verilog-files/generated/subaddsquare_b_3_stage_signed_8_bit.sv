(* use_dsp = "yes" *) module subaddsquare_b_3_stage_signed_8_bit(
	input signed [7:0] b,
	input signed [7:0] c,
	input signed [7:0] d,
	output [7:0] out,
	input clk);

	logic signed [15:0] stage0;
	logic signed [15:0] stage1;
	logic signed [15:0] stage2;

	always @(posedge clk) begin
	stage0 <= c - ((d + b) * (d + b));
	stage1 <= stage0;
	stage2 <= stage1;
	end

	assign out = stage2;
endmodule
