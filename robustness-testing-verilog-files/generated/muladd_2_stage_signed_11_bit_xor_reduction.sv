(* use_dsp = "yes" *) module muladd_2_stage_signed_11_bit_xor_reduction(
	input signed [10:0] a,
	input signed [10:0] b,
	input signed [10:0] c,
	output [10:0] out,
	input clk);

	logic signed [21:0] stage0;
	logic signed [21:0] stage1;

	always @(posedge clk) begin
	stage0 <= (a * b) + c;
	stage1 <= stage0;
	end

	assign out = ^(stage1);
endmodule
