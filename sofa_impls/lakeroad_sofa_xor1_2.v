/* Generated by Yosys 0.19 (git sha1 a45c131b37c, clang 13.1.6 -fPIC -Os) */

module lakeroad_sofa_xor1_2(a, b, out0);
  wire _0_;
  wire _1_;
  input a;
  wire a;
  input b;
  wire b;
  wire lut4_out_0;
  output out0;
  wire out0;
  frac_lut4 lut4_0 (
    .in({ 2'h0, b, a }),
    .lut3_out({ _1_, _0_ }),
    .lut4_out(out0),
    .mode(1'h0),
    .mode_inv(1'h0),
    .sram(16'heffe),
    .sram_inv(16'h0000)
  );
  assign lut4_out_0 = out0;
endmodule

