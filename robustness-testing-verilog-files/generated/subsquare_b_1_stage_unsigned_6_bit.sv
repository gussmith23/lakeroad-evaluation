(* use_dsp = "yes" *) module subsquare_b_1_stage_unsigned_6_bit(
	input  [5:0] b,
	input  [5:0] d,
	output [5:0] out,
	input clk);

	logic  [11:0] stage0;

	always @(posedge clk) begin
	stage0 <= (d - b) * (d - b);

	end

	assign out = stage0;
endmodule
