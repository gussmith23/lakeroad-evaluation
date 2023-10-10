(* use_dsp = "yes" *) module mult_1_stage_unsigned_1_bit(
	input  [0:0] a,
	input  [0:0] b,
	output [0:0] out,
	input clk);

	logic  [1:0] stage0;

	always @(posedge clk) begin
	stage0 <= a * b;

	end

	assign out = stage0;
endmodule
