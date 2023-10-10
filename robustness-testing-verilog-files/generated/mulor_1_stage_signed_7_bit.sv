(* use_dsp = "yes" *) module mulor_1_stage_signed_7_bit(
	input signed [6:0] a,
	input signed [6:0] b,
	input signed [6:0] c,
	output [6:0] out,
	input clk);

	logic signed [13:0] stage0;

	always @(posedge clk) begin
	stage0 <= (a * b) | c;

	end

	assign out = stage0;
endmodule
