(* use_dsp = "yes" *) module mult_1_stage_unsigned_7_bit(
	input  [6:0] a,
	input  [6:0] b,
	output [6:0] out,
	input clk);

	logic  [13:0] stage0;

	always @(posedge clk) begin
	stage0 <= a * b;

	end

	assign out = stage0;
endmodule
