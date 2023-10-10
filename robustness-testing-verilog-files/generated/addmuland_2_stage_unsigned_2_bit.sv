(* use_dsp = "yes" *) module addmuland_2_stage_unsigned_2_bit(
	input  [1:0] a,
	input  [1:0] b,
	input  [1:0] c,
	input  [1:0] d,
	output [1:0] out,
	input clk);

	logic  [3:0] stage0;
	logic  [3:0] stage1;

	always @(posedge clk) begin
	stage0 <= ((d + a) * b) & c;
	stage1 <= stage0;
	end

	assign out = stage1;
endmodule
