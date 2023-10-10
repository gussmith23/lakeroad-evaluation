(* use_dsp = "yes" *) module mulsub_1_stage_unsigned_1_bit(
	input  [0:0] a,
	input  [0:0] b,
	input  [0:0] c,
	output [0:0] out,
	input clk);

	logic  [1:0] stage0;

	always @(posedge clk) begin
	stage0 <= (a * b) - c;

	end

	assign out = stage0;
endmodule
