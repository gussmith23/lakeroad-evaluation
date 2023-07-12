(* use_dsp = "yes" *) module preaddmul_3_stage_unsigned_9_bit(
	input  [8:0] d,
	input  [8:0] a,
	input  [8:0] b,
	output [8:0] out,
	input clk);

	logic  [17:0] stage0;
	logic  [17:0] stage1;
	logic  [17:0] stage2;

	always @(posedge clk) begin
	stage0 <= (d + a) * b;
	stage1 <= stage0;
	stage2 <= stage1;
	end

	assign out = stage2;
endmodule
