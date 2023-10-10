(* use_dsp = "yes" *) module mulor_1_stage_signed_2_bit(
	input signed [1:0] a,
	input signed [1:0] b,
	input signed [1:0] c,
	output [1:0] out,
	input clk);

	logic signed [3:0] stage0;

	always @(posedge clk) begin
	stage0 <= (a * b) | c;

	end

	assign out = stage0;
endmodule
