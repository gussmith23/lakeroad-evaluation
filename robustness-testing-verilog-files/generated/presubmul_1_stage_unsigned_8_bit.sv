(* use_dsp = "yes" *) module presubmul_1_stage_unsigned_8_bit(
	input  [7:0] a,
	input  [7:0] b,
	input  [7:0] c,
	input  [7:0] d,
	output [7:0] out,
	input clk);

	logic  [15:0] stage0;

	always @(posedge clk) begin
	stage0 <= (d - a) * b;

	end

	assign out = stage0;
endmodule
