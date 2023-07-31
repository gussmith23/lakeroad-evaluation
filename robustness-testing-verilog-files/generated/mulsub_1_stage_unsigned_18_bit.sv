(* use_dsp = "yes" *) module mulsub_1_stage_unsigned_18_bit(
	input  [17:0] a,
	input  [17:0] b,
	input  [17:0] c,
	output [17:0] out,
	input clk);

	logic  [35:0] stage0;

	always @(posedge clk) begin
	stage0 <= (a * b) - c;

	end

	assign out = stage0;
endmodule
