(* use_dsp = "yes" *) module addmuladd_2_stage_unsigned_13_bit(
	input  [12:0] a,
	input  [12:0] b,
	input  [12:0] c,
	input  [12:0] d,
	output [12:0] out,
	input clk);

	logic  [25:0] stage0;
	logic  [25:0] stage1;

	always @(posedge clk) begin
	stage0 <= ((d + a) * b) + c;
	stage1 <= stage0;
	end

	assign out = stage1;
endmodule
