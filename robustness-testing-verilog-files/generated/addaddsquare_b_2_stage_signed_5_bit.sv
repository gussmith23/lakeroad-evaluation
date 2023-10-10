(* use_dsp = "yes" *) module addaddsquare_b_2_stage_signed_5_bit(
	input signed [4:0] b,
	input signed [4:0] c,
	input signed [4:0] d,
	output [4:0] out,
	input clk);

	logic signed [9:0] stage0;
	logic signed [9:0] stage1;

	always @(posedge clk) begin
	stage0 <= c + ((d + b) * (d + b));
	stage1 <= stage0;
	end

	assign out = stage1;
endmodule
