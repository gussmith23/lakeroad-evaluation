(* use_dsp = "yes" *) module mult_1_stage_unsigned_16_bit(
	input  [15:0] a,
	input  [15:0] b,
	output [15:0] out,
	input clk);

	logic  [31:0] stage0;

	always @(posedge clk) begin
	stage0 <= a * b;

	end

	assign out = stage0;
endmodule
