(* use_dsp = "yes" *) module addmulor_1_stage_unsigned_9_bit_xor_reduction(
	input  [8:0] a,
	input  [8:0] b,
	input  [8:0] c,
	input  [8:0] d,
	output [8:0] out,
	input clk);

	logic  [17:0] stage0;

	always @(posedge clk) begin
	stage0 <= ((d + a) * b) | c;

	end

	assign out = ^(stage0);
endmodule
