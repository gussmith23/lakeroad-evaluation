(* use_dsp = "yes" *) module muladdsub_1_stage_signed_8_bit(
	input signed [7:0] a,
	input signed [7:0] b,
	input signed [7:0] c,
	input signed [7:0] d,
	output [7:0] out,
	input clk);

	logic signed [15:0] stage0;

	always @(posedge clk) begin
	stage0 <= (a * b) + (c - d);

	end

	assign out = stage0;
endmodule
