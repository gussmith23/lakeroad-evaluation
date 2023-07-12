(* use_dsp = "yes" *) module addmulor_1_stage_signed_15_bit_xor_reduction(
	input signed [14:0] a,
	input signed [14:0] b,
	input signed [14:0] c,
	input signed [14:0] d,
	output [14:0] out,
	input clk);

	logic signed [29:0] stage0;

	always @(posedge clk) begin
	stage0 <= ((d + a) * b) | c;

	end

	assign out = ^(stage0);
endmodule
