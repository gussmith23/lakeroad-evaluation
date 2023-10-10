(* use_dsp = "yes" *) module subsquare_b_2_stage_signed_2_bit(
	input signed [1:0] b,
	input signed [1:0] d,
	output [1:0] out,
	input clk);

	logic signed [3:0] stage0;
	logic signed [3:0] stage1;

	always @(posedge clk) begin
	stage0 <= (d - b) * (d - b);
	stage1 <= stage0;
	end

	assign out = stage1;
endmodule
