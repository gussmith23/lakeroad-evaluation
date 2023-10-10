(* use_dsp = "yes" *) module subsquare_b_1_stage_unsigned_1_bit(
	input  [0:0] b,
	input  [0:0] d,
	output [0:0] out,
	input clk);

	logic  [1:0] stage0;

	always @(posedge clk) begin
	stage0 <= (d - b) * (d - b);

	end

	assign out = stage0;
endmodule
