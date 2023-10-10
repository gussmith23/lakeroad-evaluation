(* use_dsp = "yes" *) module preaddmul_1_stage_unsigned_7_bit(
	input  [6:0] a,
	input  [6:0] b,
	input  [6:0] d,
	output [6:0] out,
	input clk);

	logic  [13:0] stage0;

	always @(posedge clk) begin
	stage0 <= (d + a) * b;

	end

	assign out = stage0;
endmodule
