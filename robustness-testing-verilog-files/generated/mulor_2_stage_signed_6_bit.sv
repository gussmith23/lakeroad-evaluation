(* use_dsp = "yes" *) module mulor_2_stage_signed_6_bit(
	input signed [5:0] a,
	input signed [5:0] b,
	input signed [5:0] c,
	output [5:0] out,
	input clk);

	logic signed [11:0] stage0;
	logic signed [11:0] stage1;

	always @(posedge clk) begin
	stage0 <= (a * b) | c;
	stage1 <= stage0;
	end

	assign out = stage1;
endmodule
