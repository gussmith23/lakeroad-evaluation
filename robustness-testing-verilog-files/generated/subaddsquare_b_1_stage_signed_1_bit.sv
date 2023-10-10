(* use_dsp = "yes" *) module subaddsquare_b_1_stage_signed_1_bit(
	input signed [0:0] b,
	input signed [0:0] c,
	input signed [0:0] d,
	output [0:0] out,
	input clk);

	logic signed [1:0] stage0;

	always @(posedge clk) begin
	stage0 <= c - ((d + b) * (d + b));

	end

	assign out = stage0;
endmodule
