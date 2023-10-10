(* use_dsp = "yes" *) module subsubsquare_a_1_stage_signed_2_bit(
	input signed [1:0] a,
	input signed [1:0] c,
	input signed [1:0] d,
	output [1:0] out,
	input clk);

	logic signed [3:0] stage0;

	always @(posedge clk) begin
	stage0 <= c - ((d - a) * (d - a));

	end

	assign out = stage0;
endmodule
