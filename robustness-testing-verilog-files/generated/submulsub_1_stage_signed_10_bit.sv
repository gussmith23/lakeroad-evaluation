(* use_dsp = "yes" *) module submulsub_1_stage_signed_10_bit(
	input signed [9:0] a,
	input signed [9:0] b,
	input signed [9:0] c,
	input signed [9:0] d,
	output [9:0] out,
	input clk);

	logic signed [19:0] stage0;

	always @(posedge clk) begin
	stage0 <= ((d - a) * b) - c;

	end

	assign out = stage0;
endmodule
