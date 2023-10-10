(* use_dsp = "yes" *) module mult_1_stage_signed_4_bit(
	input signed [3:0] a,
	input signed [3:0] b,
	output [3:0] out,
	input clk);

	logic signed [7:0] stage0;

	always @(posedge clk) begin
	stage0 <= a * b;

	end

	assign out = stage0;
endmodule
