(* use_dsp = "yes" *) module mult_1_stage_unsigned_12_bit(
	input  [11:0] a,
	input  [11:0] b,
	output [11:0] out,
	input clk);

	logic  [23:0] stage0;

	always @(posedge clk) begin
	stage0 <= a * b;

	end

	assign out = stage0;
endmodule
