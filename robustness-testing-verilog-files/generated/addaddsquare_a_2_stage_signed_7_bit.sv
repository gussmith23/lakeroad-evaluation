(* use_dsp = "yes" *) module addaddsquare_a_2_stage_signed_7_bit(
	input signed [6:0] a,
	input signed [6:0] c,
	input signed [6:0] d,
	output [6:0] out,
	input clk);

	logic signed [13:0] stage0;
	logic signed [13:0] stage1;

	always @(posedge clk) begin
	stage0 <= c + ((d + a) * (d + a));
	stage1 <= stage0;
	end

	assign out = stage1;
endmodule
