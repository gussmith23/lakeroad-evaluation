(* use_dsp = "yes" *) module addmulor_2_stage_unsigned_10_bit_xor_reduction(
	input  [9:0] a,
	input  [9:0] b,
	input  [9:0] c,
	input  [9:0] d,
	output [9:0] out,
	input clk);

	logic  [19:0] stage0;
	logic  [19:0] stage1;

	always @(posedge clk) begin
	stage0 <= ((d + a) * b) | c;
	stage1 <= stage0;
	end

	assign out = ^(stage1);
endmodule
