(* use_dsp = "yes" *) module addaddsquare_b_3_stage_signed_5_bit(
	input signed [4:0] b,
	input signed [4:0] c,
	input signed [4:0] d,
	output [4:0] out,
	input clk);

	logic signed [9:0] stage0;
	logic signed [9:0] stage1;
	logic signed [9:0] stage2;

	always @(posedge clk) begin
	stage0 <= c + ((d + b) * (d + b));
	stage1 <= stage0;
	stage2 <= stage1;
	end

	assign out = stage2;
endmodule
