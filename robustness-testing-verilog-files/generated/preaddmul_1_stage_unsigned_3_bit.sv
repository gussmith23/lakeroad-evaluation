(* use_dsp = "yes" *) module preaddmul_1_stage_unsigned_3_bit(
	input  [2:0] a,
	input  [2:0] b,
	input  [2:0] d,
	output [2:0] out,
	input clk);

	logic  [5:0] stage0;

	always @(posedge clk) begin
	stage0 <= (d + a) * b;

	end

	assign out = stage0;
endmodule
