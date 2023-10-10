(* use_dsp = "yes" *) module subaddsquare_a_1_stage_unsigned_6_bit(
	input  [5:0] a,
	input  [5:0] c,
	input  [5:0] d,
	output [5:0] out,
	input clk);

	logic  [11:0] stage0;

	always @(posedge clk) begin
	stage0 <= c - ((d + a) * (d + a));

	end

	assign out = stage0;
endmodule
