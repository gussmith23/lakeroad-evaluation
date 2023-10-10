(* use_dsp = "yes" *) module addmulor_2_stage_unsigned_7_bit(
	input  [6:0] a,
	input  [6:0] b,
	input  [6:0] c,
	input  [6:0] d,
	output [6:0] out,
	input clk);

	logic  [13:0] stage0;
	logic  [13:0] stage1;

	always @(posedge clk) begin
	stage0 <= ((d + a) * b) | c;
	stage1 <= stage0;
	end

	assign out = stage1;
endmodule
