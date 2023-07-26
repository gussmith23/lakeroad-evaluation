(* use_dsp = "yes" *) module mulsubadd_1_stage_unsigned_15_bit(
	input  [14:0] a,
	input  [14:0] b,
	input  [14:0] c,
	input  [14:0] d,
	output [14:0] out,
	input clk);

	logic  [29:0] stage0;

	always @(posedge clk) begin
	stage0 <= (a * b) - (c + d);

	end

	assign out = stage0;
endmodule
