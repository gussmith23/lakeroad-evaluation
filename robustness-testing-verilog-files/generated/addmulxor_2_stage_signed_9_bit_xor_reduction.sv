(* use_dsp = "yes" *) module addmulxor_2_stage_signed_9_bit_xor_reduction(
	input signed [8:0] a,
	input signed [8:0] b,
	input signed [8:0] c,
	input signed [8:0] d,
	output [8:0] out,
	input clk);

	logic signed [17:0] stage0;
	logic signed [17:0] stage1;

	always @(posedge clk) begin
	stage0 <= ((d + a) * b) ^ c;
	stage1 <= stage0;
	end

	assign out = ^(stage1);
endmodule
