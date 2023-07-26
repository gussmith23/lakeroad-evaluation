(* use_dsp = "yes" *) module muladd_1_stage_signed_18_bit_xor_reduction(
	input signed [17:0] a,
	input signed [17:0] b,
	input signed [17:0] c,
	output [17:0] out,
	input clk);

	logic signed [35:0] stage0;

	always @(posedge clk) begin
	stage0 <= (a * b) + c;

	end

	assign out = ^(stage0);
endmodule
