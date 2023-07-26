(* use_dsp = "yes" *) module mulsub_1_stage_unsigned_12_bit(
	input  [11:0] a,
	input  [11:0] b,
	input  [11:0] c,
	output [11:0] out,
	input clk);

	logic  [23:0] stage0;

	always @(posedge clk) begin
	stage0 <= (a * b) - c;

	end

	assign out = stage0;
endmodule
