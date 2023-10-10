(* use_dsp = "yes" *) module preaddmul_1_stage_unsigned_4_bit(
	input  [3:0] a,
	input  [3:0] b,
	input  [3:0] d,
	output [3:0] out,
	input clk);

	logic  [7:0] stage0;

	always @(posedge clk) begin
	stage0 <= (d + a) * b;

	end

	assign out = stage0;
endmodule
