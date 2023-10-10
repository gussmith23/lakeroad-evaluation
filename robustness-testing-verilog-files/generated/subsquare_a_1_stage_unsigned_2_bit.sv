(* use_dsp = "yes" *) module subsquare_a_1_stage_unsigned_2_bit(
	input  [1:0] a,
	input  [1:0] d,
	output [1:0] out,
	input clk);

	logic  [3:0] stage0;

	always @(posedge clk) begin
	stage0 <= (d - a) * (d - a);

	end

	assign out = stage0;
endmodule
