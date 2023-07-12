(* use_dsp = "yes" *) module submulxor_2_stage_signed_11_bit(
	input signed [10:0] a,
	input signed [10:0] b,
	input signed [10:0] c,
	input signed [10:0] d,
	output [10:0] out,
	input clk);

	logic signed [21:0] stage0;
	logic signed [21:0] stage1;

	always @(posedge clk) begin
	stage0 <= ((d - a) * b) ^ c;
	stage1 <= stage0;
	end

	assign out = stage1;
endmodule
