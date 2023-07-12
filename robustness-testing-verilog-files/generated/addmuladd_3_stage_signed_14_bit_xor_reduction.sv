(* use_dsp = "yes" *) module addmuladd_3_stage_signed_14_bit_xor_reduction(
	input signed [13:0] a,
	input signed [13:0] b,
	input signed [13:0] c,
	input signed [13:0] d,
	output [13:0] out,
	input clk);

	logic signed [27:0] stage0;
	logic signed [27:0] stage1;
	logic signed [27:0] stage2;

	always @(posedge clk) begin
	stage0 <= ((d + a) * b) + c;
	stage1 <= stage0;
	stage2 <= stage1;
	end

	assign out = ^(stage2);
endmodule
