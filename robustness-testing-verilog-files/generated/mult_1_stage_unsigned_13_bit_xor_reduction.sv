(* use_dsp = "yes" *) module mult_1_stage_unsigned_13_bit_xor_reduction(
	input  [12:0] a,
	input  [12:0] b,
	output [12:0] out,
	input clk);

	logic  [25:0] stage0;

	always @(posedge clk) begin
	stage0 <= a * b;

	end

	assign out = ^(stage0);
endmodule
