(* use_dsp = "yes" *) module addsquare_a_1_stage_signed_6_bit(
	input signed [5:0] a,
	input signed [5:0] d,
	output [5:0] out,
	input clk);

	logic signed [11:0] stage0;

	always @(posedge clk) begin
	stage0 <= (d + a) * (d + a);

	end

	assign out = stage0;
endmodule
