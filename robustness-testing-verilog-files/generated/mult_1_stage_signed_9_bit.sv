(* use_dsp = "yes" *) module mult_1_stage_signed_9_bit(
	input signed [8:0] a,
	input signed [8:0] b,
	output [8:0] out,
	input clk);

	logic signed [17:0] stage0;

	always @(posedge clk) begin
	stage0 <= a * b;

	end

	assign out = stage0;
endmodule
