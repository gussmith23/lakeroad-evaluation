/* Generated by Yosys 0.15+50 (git sha1 6318db615, x86_64-apple-darwin20.2-clang 10.0.0-4ubuntu1 -fPIC -Os) */

module lakeroad_sofa_and16_2(a, b, out0);
  wire _00_;
  wire _01_;
  wire _02_;
  wire _03_;
  wire _04_;
  wire _05_;
  wire _06_;
  wire _07_;
  wire _08_;
  wire _09_;
  wire _10_;
  wire _11_;
  wire _12_;
  wire _13_;
  wire _14_;
  wire _15_;
  wire _16_;
  wire _17_;
  wire _18_;
  wire _19_;
  wire _20_;
  wire _21_;
  wire _22_;
  wire _23_;
  wire _24_;
  wire _25_;
  wire _26_;
  wire _27_;
  wire _28_;
  wire _29_;
  wire _30_;
  wire _31_;
  input [15:0] a;
  wire [15:0] a;
  input [15:0] b;
  wire [15:0] b;
  wire lut4_out_0;
  wire lut4_out_1;
  wire lut4_out_10;
  wire lut4_out_11;
  wire lut4_out_12;
  wire lut4_out_13;
  wire lut4_out_14;
  wire lut4_out_15;
  wire lut4_out_2;
  wire lut4_out_3;
  wire lut4_out_4;
  wire lut4_out_5;
  wire lut4_out_6;
  wire lut4_out_7;
  wire lut4_out_8;
  wire lut4_out_9;
  output [15:0] out0;
  wire [15:0] out0;
  frac_lut4 lut4_0 (
    .in({ 2'h0, b[0], a[0] }),
    .lut3_out({ _25_, _24_ }),
    .lut4_out(out0[0]),
    .mode(1'h0),
    .mode_inv(1'h0),
    .sram(16'hfeee),
    .sram_inv(16'h0000)
  );
  frac_lut4 lut4_1 (
    .in({ 2'h0, b[1], a[1] }),
    .lut3_out({ _23_, _21_ }),
    .lut4_out(out0[1]),
    .mode(1'h0),
    .mode_inv(1'h0),
    .sram(16'hfeee),
    .sram_inv(16'h0000)
  );
  frac_lut4 lut4_10 (
    .in({ 2'h0, b[10], a[10] }),
    .lut3_out({ _20_, _19_ }),
    .lut4_out(out0[10]),
    .mode(1'h0),
    .mode_inv(1'h0),
    .sram(16'hfeee),
    .sram_inv(16'h0000)
  );
  frac_lut4 lut4_11 (
    .in({ 2'h0, b[11], a[11] }),
    .lut3_out({ _18_, _17_ }),
    .lut4_out(out0[11]),
    .mode(1'h0),
    .mode_inv(1'h0),
    .sram(16'hfeee),
    .sram_inv(16'h0000)
  );
  frac_lut4 lut4_12 (
    .in({ 2'h0, b[12], a[12] }),
    .lut3_out({ _16_, _15_ }),
    .lut4_out(out0[12]),
    .mode(1'h0),
    .mode_inv(1'h0),
    .sram(16'hfeee),
    .sram_inv(16'h0000)
  );
  frac_lut4 lut4_13 (
    .in({ 2'h0, b[13], a[13] }),
    .lut3_out({ _14_, _13_ }),
    .lut4_out(out0[13]),
    .mode(1'h0),
    .mode_inv(1'h0),
    .sram(16'hfeee),
    .sram_inv(16'h0000)
  );
  frac_lut4 lut4_14 (
    .in({ 2'h0, b[14], a[14] }),
    .lut3_out({ _12_, _10_ }),
    .lut4_out(out0[14]),
    .mode(1'h0),
    .mode_inv(1'h0),
    .sram(16'hfeee),
    .sram_inv(16'h0000)
  );
  frac_lut4 lut4_15 (
    .in({ 2'h0, b[15], a[15] }),
    .lut3_out({ _09_, _08_ }),
    .lut4_out(out0[15]),
    .mode(1'h0),
    .mode_inv(1'h0),
    .sram(16'hfeee),
    .sram_inv(16'h0000)
  );
  frac_lut4 lut4_2 (
    .in({ 2'h0, b[2], a[2] }),
    .lut3_out({ _07_, _06_ }),
    .lut4_out(out0[2]),
    .mode(1'h0),
    .mode_inv(1'h0),
    .sram(16'hfeee),
    .sram_inv(16'h0000)
  );
  frac_lut4 lut4_3 (
    .in({ 2'h0, b[3], a[3] }),
    .lut3_out({ _05_, _04_ }),
    .lut4_out(out0[3]),
    .mode(1'h0),
    .mode_inv(1'h0),
    .sram(16'hfeee),
    .sram_inv(16'h0000)
  );
  frac_lut4 lut4_4 (
    .in({ 2'h0, b[4], a[4] }),
    .lut3_out({ _03_, _02_ }),
    .lut4_out(out0[4]),
    .mode(1'h0),
    .mode_inv(1'h0),
    .sram(16'hfeee),
    .sram_inv(16'h0000)
  );
  frac_lut4 lut4_5 (
    .in({ 2'h0, b[5], a[5] }),
    .lut3_out({ _01_, _31_ }),
    .lut4_out(out0[5]),
    .mode(1'h0),
    .mode_inv(1'h0),
    .sram(16'hfeee),
    .sram_inv(16'h0000)
  );
  frac_lut4 lut4_6 (
    .in({ 2'h0, b[6], a[6] }),
    .lut3_out({ _30_, _29_ }),
    .lut4_out(out0[6]),
    .mode(1'h0),
    .mode_inv(1'h0),
    .sram(16'hfeee),
    .sram_inv(16'h0000)
  );
  frac_lut4 lut4_7 (
    .in({ 2'h0, b[7], a[7] }),
    .lut3_out({ _28_, _27_ }),
    .lut4_out(out0[7]),
    .mode(1'h0),
    .mode_inv(1'h0),
    .sram(16'hfeee),
    .sram_inv(16'h0000)
  );
  frac_lut4 lut4_8 (
    .in({ 2'h0, b[8], a[8] }),
    .lut3_out({ _26_, _22_ }),
    .lut4_out(out0[8]),
    .mode(1'h0),
    .mode_inv(1'h0),
    .sram(16'hfeee),
    .sram_inv(16'h0000)
  );
  frac_lut4 lut4_9 (
    .in({ 2'h0, b[9], a[9] }),
    .lut3_out({ _11_, _00_ }),
    .lut4_out(out0[9]),
    .mode(1'h0),
    .mode_inv(1'h0),
    .sram(16'hfeee),
    .sram_inv(16'h0000)
  );
  assign lut4_out_0 = out0[0];
  assign lut4_out_1 = out0[1];
  assign lut4_out_10 = out0[10];
  assign lut4_out_11 = out0[11];
  assign lut4_out_12 = out0[12];
  assign lut4_out_13 = out0[13];
  assign lut4_out_14 = out0[14];
  assign lut4_out_15 = out0[15];
  assign lut4_out_2 = out0[2];
  assign lut4_out_3 = out0[3];
  assign lut4_out_4 = out0[4];
  assign lut4_out_5 = out0[5];
  assign lut4_out_6 = out0[6];
  assign lut4_out_7 = out0[7];
  assign lut4_out_8 = out0[8];
  assign lut4_out_9 = out0[9];
endmodule

