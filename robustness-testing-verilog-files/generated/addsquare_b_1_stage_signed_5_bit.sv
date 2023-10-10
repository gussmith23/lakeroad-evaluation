(* use_dsp = "yes" *) module addsquare_b_1_stage_signed_5_bit(
	input signed [4:0] a,
	input signed [4:0] d,
	output [4:0] out,
	input clk);

	logic signed [9:0] stage0;

	always @(posedge clk) begin
	stage0 <= (d - a) * (d - a);

	end

	assign out = stage0;
endmodule
