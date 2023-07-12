(* use_dsp = "yes" *) module preaddmul_3_stage_unsigned_18_bit(
	input  [17:0] d,
	input  [17:0] a,
	input  [17:0] b,
	output [17:0] out,
	input clk);

	logic  [35:0] stage0;
	logic  [35:0] stage1;
	logic  [35:0] stage2;

	always @(posedge clk) begin
	stage0 <= (d + a) * b;
	stage1 <= stage0;
	stage2 <= stage1;
	end

	assign out = stage2;
endmodule
