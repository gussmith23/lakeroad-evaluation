(* use_dsp = "yes" *) module mulsubsub_2_stage_unsigned_18_bit(
	input  [17:0] a,
	input  [17:0] b,
	input  [17:0] c,
	input  [17:0] d,
	output [17:0] out,
	input clk);

	logic  [35:0] stage0;
	logic  [35:0] stage1;

	always @(posedge clk) begin
	stage0 <= (a * b) - (c - d);
	stage1 <= stage0;
	end

	assign out = stage1;
endmodule
