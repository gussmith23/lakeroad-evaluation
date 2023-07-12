(* use_dsp = "yes" *) module preaddmul_1_stage_unsigned_10_bit(
	input  [9:0] d,
	input  [9:0] a,
	input  [9:0] b,
	output [9:0] out,
	input clk);

	logic  [19:0] stage0;

	always @(posedge clk) begin
	stage0 <= (d + a) * b;

	end

	assign out = stage0;
endmodule
