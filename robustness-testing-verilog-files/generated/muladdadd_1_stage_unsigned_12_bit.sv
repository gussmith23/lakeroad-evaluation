(* use_dsp = "yes" *) module muladdadd_1_stage_unsigned_12_bit(
	input  [11:0] a,
	input  [11:0] b,
	input  [11:0] c,
	input  [11:0] d,
	output [11:0] out,
	input clk);

	logic  [23:0] stage0;

	always @(posedge clk) begin
	stage0 <= (a * b) + (c + d);

	end

	assign out = stage0;
endmodule
