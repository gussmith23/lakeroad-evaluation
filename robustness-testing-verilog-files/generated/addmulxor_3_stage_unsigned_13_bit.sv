(* use_dsp = "yes" *) module addmulxor_3_stage_unsigned_13_bit(
	input  [12:0] a,
	input  [12:0] b,
	input  [12:0] c,
	input  [12:0] d,
	output [12:0] out,
	input clk);

	logic  [25:0] stage0;
	logic  [25:0] stage1;
	logic  [25:0] stage2;

	always @(posedge clk) begin
	stage0 <= ((d + a) * b) ^ c;
	stage1 <= stage0;
	stage2 <= stage1;
	end

	assign out = stage2;
endmodule
