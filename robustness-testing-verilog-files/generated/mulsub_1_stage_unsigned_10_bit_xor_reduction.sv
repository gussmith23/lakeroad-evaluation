(* use_dsp = "yes" *) module mulsub_1_stage_unsigned_10_bit_xor_reduction(
	input  [9:0] a,
	input  [9:0] b,
	input  [9:0] c,
	output [9:0] out,
	input clk);

	logic  [19:0] stage0;

	always @(posedge clk) begin
	stage0 <= (a * b) - c;

	end

	assign out = ^(stage0);
endmodule
