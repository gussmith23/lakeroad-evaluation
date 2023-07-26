(* use_dsp = "yes" *) module mult_1_stage_unsigned_18_bit(
	input  [17:0] a,
	input  [17:0] b,
	output [17:0] out,
	input clk);

	logic  [35:0] stage0;

	always @(posedge clk) begin
	stage0 <= a * b;

	end

	assign out = stage0;
endmodule
