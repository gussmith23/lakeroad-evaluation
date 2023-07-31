(* use_dsp = "yes" *) module mulxor_2_stage_signed_17_bit(
	input signed [16:0] a,
	input signed [16:0] b,
	input signed [16:0] c,
	output [16:0] out,
	input clk);

	logic signed [33:0] stage0;
	logic signed [33:0] stage1;

	always @(posedge clk) begin
	stage0 <= (a * b) ^ c;
	stage1 <= stage0;
	end

	assign out = stage1;
endmodule
