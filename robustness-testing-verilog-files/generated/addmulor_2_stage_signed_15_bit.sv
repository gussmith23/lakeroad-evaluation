(* use_dsp = "yes" *) module addmulor_2_stage_signed_15_bit(
	input signed [14:0] a,
	input signed [14:0] b,
	input signed [14:0] c,
	input signed [14:0] d,
	output [14:0] out,
	input clk);

	logic signed [29:0] stage0;
	logic signed [29:0] stage1;

	always @(posedge clk) begin
	stage0 <= ((d + a) * b) | c;
	stage1 <= stage0;
	end

	assign out = stage1;
endmodule
