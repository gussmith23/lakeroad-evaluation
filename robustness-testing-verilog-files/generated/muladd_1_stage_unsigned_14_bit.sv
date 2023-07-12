(* use_dsp = "yes" *) module muladd_1_stage_unsigned_14_bit(
	input  [13:0] a,
	input  [13:0] b,
	input  [13:0] c,
	output [13:0] out,
	input clk);

	logic  [27:0] stage0;

	always @(posedge clk) begin
	stage0 <= (a * b) + c;

	end

	assign out = stage0;
endmodule
