(* use_dsp = "yes" *) module submulsub_3_stage_unsigned_17_bit(
	input  [16:0] a,
	input  [16:0] b,
	input  [16:0] c,
	input  [16:0] d,
	output [16:0] out,
	input clk);

	logic  [33:0] stage0;
	logic  [33:0] stage1;
	logic  [33:0] stage2;

	always @(posedge clk) begin
	stage0 <= ((d - a) * b) - c;
	stage1 <= stage0;
	stage2 <= stage1;
	end

	assign out = stage2;
endmodule
