(* use_dsp = "yes" *) module mulxor_1_stage_unsigned_8_bit(
	input  [7:0] a,
	input  [7:0] b,
	input  [7:0] c,
	output [7:0] out,
	input clk);

	logic  [15:0] stage0;

	always @(posedge clk) begin
	stage0 <= (a * b) ^ c;

	end

	assign out = stage0;
endmodule
