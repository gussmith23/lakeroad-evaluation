(* use_dsp = "yes" *) module submuladd_1_stage_signed_12_bit(
	input signed [11:0] a,
	input signed [11:0] b,
	input signed [11:0] c,
	input signed [11:0] d,
	output [11:0] out,
	input clk);

	logic signed [23:0] stage0;

	always @(posedge clk) begin
	stage0 <= ((d - a) * b) + c;

	end

	assign out = stage0;
endmodule
