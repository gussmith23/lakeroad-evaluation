(* use_dsp = "yes" *) module mulor_3_stage_signed_15_bit(
	input signed [14:0] a,
	input signed [14:0] b,
	input signed [14:0] c,
	output [14:0] out,
	input clk);

	logic signed [29:0] stage0;
	logic signed [29:0] stage1;
	logic signed [29:0] stage2;

	always @(posedge clk) begin
	stage0 <= (a * b) | c;
	stage1 <= stage0;
	stage2 <= stage1;
	end

	assign out = stage2;
endmodule
