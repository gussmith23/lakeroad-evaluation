(* use_dsp = "yes" *) module submulor_2_stage_signed_3_bit(
	input signed [2:0] a,
	input signed [2:0] b,
	input signed [2:0] c,
	input signed [2:0] d,
	output [2:0] out,
	input clk);

	logic signed [5:0] stage0;
	logic signed [5:0] stage1;

	always @(posedge clk) begin
	stage0 <= ((d - a) * b) | c;
	stage1 <= stage0;
	end

	assign out = stage1;
endmodule
