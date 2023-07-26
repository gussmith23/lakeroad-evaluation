(* use_dsp = "yes" *) module submulor_3_stage_unsigned_18_bit_xor_reduction(
	input  [17:0] a,
	input  [17:0] b,
	input  [17:0] c,
	input  [17:0] d,
	output [17:0] out,
	input clk);

	logic  [35:0] stage0;
	logic  [35:0] stage1;
	logic  [35:0] stage2;

	always @(posedge clk) begin
	stage0 <= ((d - a) * b) | c;
	stage1 <= stage0;
	stage2 <= stage1;
	end

	assign out = ^(stage2);
endmodule
