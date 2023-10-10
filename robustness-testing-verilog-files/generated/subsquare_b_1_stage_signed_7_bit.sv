(* use_dsp = "yes" *) module subsquare_b_1_stage_signed_7_bit(
	input signed [6:0] b,
	input signed [6:0] d,
	output [6:0] out,
	input clk);

	logic signed [13:0] stage0;

	always @(posedge clk) begin
	stage0 <= (d - b) * (d - b);

	end

	assign out = stage0;
endmodule
