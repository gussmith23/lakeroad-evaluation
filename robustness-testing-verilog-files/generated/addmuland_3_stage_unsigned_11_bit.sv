(* use_dsp = "yes" *) module addmuland_3_stage_unsigned_11_bit(
	input  [10:0] a,
	input  [10:0] b,
	input  [10:0] c,
	input  [10:0] d,
	output [10:0] out,
	input clk);

	logic  [21:0] stage0;
	logic  [21:0] stage1;
	logic  [21:0] stage2;

	always @(posedge clk) begin
	stage0 <= ((d + a) * b) & c;
	stage1 <= stage0;
	stage2 <= stage1;
	end

	assign out = stage2;
endmodule
