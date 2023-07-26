(* use_dsp = "yes" *) module submulxor_3_stage_unsigned_16_bit(
	input  [15:0] a,
	input  [15:0] b,
	input  [15:0] c,
	input  [15:0] d,
	output [15:0] out,
	input clk);

	logic  [31:0] stage0;
	logic  [31:0] stage1;
	logic  [31:0] stage2;

	always @(posedge clk) begin
	stage0 <= ((d - a) * b) ^ c;
	stage1 <= stage0;
	stage2 <= stage1;
	end

	assign out = stage2;
endmodule
