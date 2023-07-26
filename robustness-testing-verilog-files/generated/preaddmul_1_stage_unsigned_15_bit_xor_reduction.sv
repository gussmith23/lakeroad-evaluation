(* use_dsp = "yes" *) module preaddmul_1_stage_unsigned_15_bit_xor_reduction(
	input  [14:0] d,
	input  [14:0] a,
	input  [14:0] b,
	output [14:0] out,
	input clk);

	logic  [29:0] stage0;

	always @(posedge clk) begin
	stage0 <= (d + a) * b;

	end

	assign out = ^(stage0);
endmodule
