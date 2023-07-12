(* use_dsp = "yes" *) module mulsub_1_stage_signed_16_bit(
	input signed [15:0] a,
	input signed [15:0] b,
	input signed [15:0] c,
	output [15:0] out,
	input clk);

	logic signed [31:0] stage0;

	always @(posedge clk) begin
	stage0 <= (a * b) - c;

	end

	assign out = stage0;
endmodule
