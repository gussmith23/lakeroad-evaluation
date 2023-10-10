(* use_dsp = "yes" *) module mulsub_1_stage_signed_3_bit(
	input signed [2:0] a,
	input signed [2:0] b,
	input signed [2:0] c,
	output [2:0] out,
	input clk);

	logic signed [5:0] stage0;

	always @(posedge clk) begin
	stage0 <= (a * b) - c;

	end

	assign out = stage0;
endmodule
