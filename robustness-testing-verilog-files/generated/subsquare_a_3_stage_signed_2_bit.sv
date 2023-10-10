(* use_dsp = "yes" *) module subsquare_a_3_stage_signed_2_bit(
	input signed [1:0] a,
	input signed [1:0] d,
	output [1:0] out,
	input clk);

	logic signed [3:0] stage0;
	logic signed [3:0] stage1;
	logic signed [3:0] stage2;

	always @(posedge clk) begin
	stage0 <= (d - a) * (d - a);
	stage1 <= stage0;
	stage2 <= stage1;
	end

	assign out = stage2;
endmodule
