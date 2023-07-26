(* use_dsp = "yes" *) module addmulsub_1_stage_unsigned_18_bit_xor_reduction(
	input  [17:0] a,
	input  [17:0] b,
	input  [17:0] c,
	input  [17:0] d,
	output [17:0] out,
	input clk);

	logic  [35:0] stage0;

	always @(posedge clk) begin
	stage0 <= ((d + a) * b) - c;

	end

	assign out = ^(stage0);
endmodule
