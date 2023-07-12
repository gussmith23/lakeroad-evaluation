(* use_dsp = "yes" *) module muladd_1_stage_signed_17_bit(
	input signed [16:0] a,
	input signed [16:0] b,
	input signed [16:0] c,
	output [16:0] out,
	input clk);

	logic signed [33:0] stage0;

	always @(posedge clk) begin
	stage0 <= (a * b) + c;

	end

	assign out = stage0;
endmodule
