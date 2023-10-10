(* use_dsp = "yes" *) module addaddsquare_b_3_stage_signed_7_bit(
	input signed [6:0] b,
	input signed [6:0] c,
	input signed [6:0] d,
	output [6:0] out,
	input clk);

	logic signed [13:0] stage0;
	logic signed [13:0] stage1;
	logic signed [13:0] stage2;

	always @(posedge clk) begin
	stage0 <= c + ((d + b) * (d + b));
	stage1 <= stage0;
	stage2 <= stage1;
	end

	assign out = stage2;
endmodule
