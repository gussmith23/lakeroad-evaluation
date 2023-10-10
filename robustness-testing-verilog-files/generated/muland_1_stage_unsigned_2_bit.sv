(* use_dsp = "yes" *) module muland_1_stage_unsigned_2_bit(
	input  [1:0] a,
	input  [1:0] b,
	input  [1:0] c,
	output [1:0] out,
	input clk);

	logic  [3:0] stage0;

	always @(posedge clk) begin
	stage0 <= (a * b) & c;

	end

	assign out = stage0;
endmodule
