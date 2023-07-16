(* use_dsp = "yes" *) module muland_3_stage_signed_16_bit(
	input signed [15:0] a,
	input signed [15:0] b,
	input signed [15:0] c,
	output [15:0] out,
	input clk);

	logic signed [31:0] stage0;
	logic signed [31:0] stage1;
	logic signed [31:0] stage2;

	always @(posedge clk) begin
	stage0 <= (a * b) & c;
	stage1 <= stage0;
	stage2 <= stage1;
	end

	assign out = stage2;
endmodule
