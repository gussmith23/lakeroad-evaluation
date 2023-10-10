(* use_dsp = "yes" *) module muladd_2_stage_signed_3_bit(
	input signed [2:0] a,
	input signed [2:0] b,
	input signed [2:0] c,
	output [2:0] out,
	input clk);

	logic signed [5:0] stage0;
	logic signed [5:0] stage1;

	always @(posedge clk) begin
	stage0 <= (a * b) + c;
	stage1 <= stage0;
	end

	assign out = stage1;
endmodule
