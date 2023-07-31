(* use_dsp = "yes" *) module mulsubadd_2_stage_signed_9_bit(
	input signed [8:0] a,
	input signed [8:0] b,
	input signed [8:0] c,
	input signed [8:0] d,
	output [8:0] out,
	input clk);

	logic signed [17:0] stage0;
	logic signed [17:0] stage1;

	always @(posedge clk) begin
	stage0 <= (a * b) - (c + d);
	stage1 <= stage0;
	end

	assign out = stage1;
endmodule
