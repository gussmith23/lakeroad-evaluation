(* use_dsp = "yes" *) module muladdsub_1_stage_unsigned_17_bit(
	input  [16:0] a,
	input  [16:0] b,
	input  [16:0] c,
	input  [16:0] d,
	output [16:0] out,
	input clk);

	logic  [33:0] stage0;

	always @(posedge clk) begin
	stage0 <= (a * b) + (c - d);

	end

	assign out = stage0;
endmodule
