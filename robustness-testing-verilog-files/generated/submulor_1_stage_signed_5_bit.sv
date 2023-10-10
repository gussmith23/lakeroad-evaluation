(* use_dsp = "yes" *) module submulor_1_stage_signed_5_bit(
	input signed [4:0] a,
	input signed [4:0] b,
	input signed [4:0] c,
	input signed [4:0] d,
	output [4:0] out,
	input clk);

	logic signed [9:0] stage0;

	always @(posedge clk) begin
	stage0 <= ((d - a) * b) | c;

	end

	assign out = stage0;
endmodule
