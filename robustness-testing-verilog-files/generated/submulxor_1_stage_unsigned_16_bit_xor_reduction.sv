(* use_dsp = "yes" *) module submulxor_1_stage_unsigned_16_bit_xor_reduction(
	input  [15:0] a,
	input  [15:0] b,
	input  [15:0] c,
	input  [15:0] d,
	output [15:0] out,
	input clk);

	logic  [31:0] stage0;

	always @(posedge clk) begin
	stage0 <= ((d - a) * b) ^ c;

	end

	assign out = ^(stage0);
endmodule
