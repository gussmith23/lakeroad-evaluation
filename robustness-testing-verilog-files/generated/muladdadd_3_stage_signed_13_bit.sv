(* use_dsp = "yes" *) module muladdadd_3_stage_signed_13_bit(
	input signed [12:0] a,
	input signed [12:0] b,
	input signed [12:0] c,
	input signed [12:0] d,
	output [12:0] out,
	input clk);

	logic signed [25:0] stage0;
	logic signed [25:0] stage1;
	logic signed [25:0] stage2;

	always @(posedge clk) begin
	stage0 <= (a * b) + (c + d);
	stage1 <= stage0;
	stage2 <= stage1;
	end

	assign out = stage2;
endmodule
