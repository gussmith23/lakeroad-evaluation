(* use_dsp = "yes" *) module mulsubadd_2_stage_signed_14_bit(
	input signed [13:0] a,
	input signed [13:0] b,
	input signed [13:0] c,
	input signed [13:0] d,
	output [13:0] out,
	input clk);

	logic signed [27:0] stage0;
	logic signed [27:0] stage1;

	always @(posedge clk) begin
	stage0 <= (a * b) - (c + d);
	stage1 <= stage0;
	end

	assign out = stage1;
endmodule
