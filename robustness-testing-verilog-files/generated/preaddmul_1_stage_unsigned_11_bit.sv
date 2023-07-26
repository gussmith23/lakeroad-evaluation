(* use_dsp = "yes" *) module preaddmul_1_stage_unsigned_11_bit(
	input  [10:0] d,
	input  [10:0] a,
	input  [10:0] b,
	output [10:0] out,
	input clk);

	logic  [21:0] stage0;

	always @(posedge clk) begin
	stage0 <= (d + a) * b;

	end

	assign out = stage0;
endmodule
