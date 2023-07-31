(* use_dsp = "yes" *) module preaddmul_3_stage_unsigned_8_bit_xor_reduction(
	input  [7:0] d,
	input  [7:0] a,
	input  [7:0] b,
	output [7:0] out,
	input clk);

	logic  [15:0] stage0;
	logic  [15:0] stage1;
	logic  [15:0] stage2;

	always @(posedge clk) begin
	stage0 <= (d + a) * b;
	stage1 <= stage0;
	stage2 <= stage1;
	end

	assign out = ^(stage2);
endmodule
