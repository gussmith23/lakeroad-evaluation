(* use_dsp = "yes" *) module addmulxor_1_stage_unsigned_13_bit(
	input  [12:0] a,
	input  [12:0] b,
	input  [12:0] c,
	input  [12:0] d,
	output [12:0] out,
	input clk);

	logic  [25:0] stage0;

	always @(posedge clk) begin
	stage0 <= ((d + a) * b) ^ c;

	end

	assign out = stage0;
endmodule
