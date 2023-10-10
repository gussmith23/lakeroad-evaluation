(* use_dsp = "yes" *) module subaddsquare_a_1_stage_unsigned_3_bit(
	input  [2:0] a,
	input  [2:0] c,
	input  [2:0] d,
	output [2:0] out,
	input clk);

	logic  [5:0] stage0;

	always @(posedge clk) begin
	stage0 <= c - ((d + a) * (d + a));

	end

	assign out = stage0;
endmodule
