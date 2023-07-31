(* use_dsp = "yes" *) module submulxor_2_stage_signed_12_bit(
	input signed [11:0] a,
	input signed [11:0] b,
	input signed [11:0] c,
	input signed [11:0] d,
	output [11:0] out,
	input clk);

	logic signed [23:0] stage0;
	logic signed [23:0] stage1;

	always @(posedge clk) begin
	stage0 <= ((d - a) * b) ^ c;
	stage1 <= stage0;
	end

	assign out = stage1;
endmodule
