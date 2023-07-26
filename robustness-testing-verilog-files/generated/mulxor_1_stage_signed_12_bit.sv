(* use_dsp = "yes" *) module mulxor_1_stage_signed_12_bit(
	input signed [11:0] a,
	input signed [11:0] b,
	input signed [11:0] c,
	output [11:0] out,
	input clk);

	logic signed [23:0] stage0;

	always @(posedge clk) begin
	stage0 <= (a * b) ^ c;

	end

	assign out = stage0;
endmodule
