(* use_dsp = "yes" *) module mulor_1_stage_signed_15_bit(
	input signed [14:0] a,
	input signed [14:0] b,
	input signed [14:0] c,
	output [14:0] out,
	input clk);

	logic signed [29:0] stage0;

	always @(posedge clk) begin
	stage0 <= (a * b) | c;

	end

	assign out = stage0;
endmodule
