(* use_dsp = "yes" *) module mulor_3_stage_signed_5_bit(
	input signed [4:0] a,
	input signed [4:0] b,
	input signed [4:0] c,
	output [4:0] out,
	input clk);

	logic signed [9:0] stage0;
	logic signed [9:0] stage1;
	logic signed [9:0] stage2;

	always @(posedge clk) begin
	stage0 <= (a * b) | c;
	stage1 <= stage0;
	stage2 <= stage1;
	end

	assign out = stage2;
endmodule
