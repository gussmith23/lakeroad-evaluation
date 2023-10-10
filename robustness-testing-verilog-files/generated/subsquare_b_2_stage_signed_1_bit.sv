(* use_dsp = "yes" *) module subsquare_b_2_stage_signed_1_bit(
	input signed [0:0] b,
	input signed [0:0] d,
	output [0:0] out,
	input clk);

	logic signed [1:0] stage0;
	logic signed [1:0] stage1;

	always @(posedge clk) begin
	stage0 <= (d - b) * (d - b);
	stage1 <= stage0;
	end

	assign out = stage1;
endmodule
