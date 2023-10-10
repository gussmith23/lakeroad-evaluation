(* use_dsp = "yes" *) module addmuland_0_stage_signed_8_bit(
	input signed [7:0] a,
	input signed [7:0] b,
	input signed [7:0] c,
	input signed [7:0] d,
	output [7:0] out
	);

	assign out = ((d + a) * b) & c;
endmodule
