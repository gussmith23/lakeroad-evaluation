(* use_dsp = "yes" *) module mult_1_stage_signed_6_bit(
	input signed [5:0] a,
	input signed [5:0] b,
	output [5:0] out,
	input clk);

	logic signed [11:0] stage0;

	always @(posedge clk) begin
	stage0 <= a * b;

	end

	assign out = stage0;
endmodule
