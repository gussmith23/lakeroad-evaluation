(* use_dsp = "yes" *) module addsquare_b_2_stage_signed_6_bit(
	input signed [5:0] a,
	input signed [5:0] d,
	output [5:0] out,
	input clk);

	logic signed [11:0] stage0;
	logic signed [11:0] stage1;

	always @(posedge clk) begin
	stage0 <= (d - a) * (d - a);
	stage1 <= stage0;
	end

	assign out = stage1;
endmodule
