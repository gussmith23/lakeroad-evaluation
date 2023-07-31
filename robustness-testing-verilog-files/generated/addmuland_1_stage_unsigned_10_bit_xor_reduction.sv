(* use_dsp = "yes" *) module addmuland_1_stage_unsigned_10_bit_xor_reduction(
	input  [9:0] a,
	input  [9:0] b,
	input  [9:0] c,
	input  [9:0] d,
	output [9:0] out,
	input clk);

	logic  [19:0] stage0;

	always @(posedge clk) begin
	stage0 <= ((d + a) * b) & c;

	end

	assign out = ^(stage0);
endmodule
