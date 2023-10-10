(* use_dsp = "yes" *) module mult_1_stage_signed_1_bit(
	input signed [0:0] a,
	input signed [0:0] b,
	output [0:0] out,
	input clk);

	logic signed [1:0] stage0;

	always @(posedge clk) begin
	stage0 <= a * b;

	end

	assign out = stage0;
endmodule
