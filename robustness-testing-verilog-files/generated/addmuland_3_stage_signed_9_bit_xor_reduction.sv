(* use_dsp = "yes" *) module addmuland_3_stage_signed_9_bit_xor_reduction(
	input signed [8:0] a,
	input signed [8:0] b,
	input signed [8:0] c,
	input signed [8:0] d,
	output [8:0] out,
	input clk);

	logic signed [17:0] stage0;
	logic signed [17:0] stage1;
	logic signed [17:0] stage2;

	always @(posedge clk) begin
	stage0 <= ((d + a) * b) & c;
	stage1 <= stage0;
	stage2 <= stage1;
	end

	assign out = ^(stage2);
endmodule
