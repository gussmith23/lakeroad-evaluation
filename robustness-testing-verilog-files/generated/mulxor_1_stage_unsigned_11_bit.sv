(* use_dsp = "yes" *) module mulxor_1_stage_unsigned_11_bit(
	input  [10:0] a,
	input  [10:0] b,
	input  [10:0] c,
	output [10:0] out,
	input clk);

	logic  [21:0] stage0;

	always @(posedge clk) begin
	stage0 <= (a * b) ^ c;

	end

	assign out = stage0;
endmodule
