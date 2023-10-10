(* use_dsp = "yes" *) module addaddsquare_b_1_stage_signed_6_bit(
	input signed [5:0] b,
	input signed [5:0] c,
	input signed [5:0] d,
	output [5:0] out,
	input clk);

	logic signed [11:0] stage0;

	always @(posedge clk) begin
	stage0 <= c + ((d + b) * (d + b));

	end

	assign out = stage0;
endmodule
