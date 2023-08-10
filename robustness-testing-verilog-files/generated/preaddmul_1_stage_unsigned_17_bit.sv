(* use_dsp = "yes" *) module preaddmul_1_stage_unsigned_17_bit(
	input  [16:0] a,
	input  [16:0] b,
	input  [16:0] d,
	output [16:0] out,
	input clk);

	logic  [33:0] stage0;

	always @(posedge clk) begin
	stage0 <= (d + a) * b;

	end

	assign out = stage0;
endmodule
