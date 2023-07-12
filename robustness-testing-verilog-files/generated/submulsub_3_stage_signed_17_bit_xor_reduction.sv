(* use_dsp = "yes" *) module submulsub_3_stage_signed_17_bit_xor_reduction(
	input signed [16:0] a,
	input signed [16:0] b,
	input signed [16:0] c,
	input signed [16:0] d,
	output [16:0] out,
	input clk);

	logic signed [33:0] stage0;
	logic signed [33:0] stage1;
	logic signed [33:0] stage2;

	always @(posedge clk) begin
	stage0 <= ((d - a) * b) - c;
	stage1 <= stage0;
	stage2 <= stage1;
	end

	assign out = ^(stage2);
endmodule
