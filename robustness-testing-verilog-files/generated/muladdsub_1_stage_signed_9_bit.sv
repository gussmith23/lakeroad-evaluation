(* use_dsp = "yes" *) module muladdsub_1_stage_signed_9_bit(
	input signed [8:0] a,
	input signed [8:0] b,
	input signed [8:0] c,
	input signed [8:0] d,
	output [8:0] out,
	input clk);

	logic signed [17:0] stage0;

	always @(posedge clk) begin
	stage0 <= (a * b) + (c - d);

	end

	assign out = stage0;
endmodule