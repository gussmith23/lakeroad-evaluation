(* use_dsp = "yes" *) module mult_2_stage_unsigned_11_bit_xor_reduction(
	input  [10:0] a,
	input  [10:0] b,
	output [10:0] out,
	input clk);

	logic  [21:0] stage0;
	logic  [21:0] stage1;

	always @(posedge clk) begin
	stage0 <= a * b;
	stage1 <= stage0;
	end

	assign out = ^(stage1);
endmodule