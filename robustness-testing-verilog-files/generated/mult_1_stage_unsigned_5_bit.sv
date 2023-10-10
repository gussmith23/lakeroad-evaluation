(* use_dsp = "yes" *) module mult_1_stage_unsigned_5_bit(
	input  [4:0] a,
	input  [4:0] b,
	output [4:0] out,
	input clk);

	logic  [9:0] stage0;

	always @(posedge clk) begin
	stage0 <= a * b;

	end

	assign out = stage0;
endmodule
