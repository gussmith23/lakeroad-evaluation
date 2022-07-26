/* Generated by Yosys 0.19 (git sha1 a45c131b37c, clang 13.1.6 -fPIC -Os) */

module lakeroad_xilinx_ultrascale_plus_add64_2(a, b, out0);
  input [63:0] a;
  wire [63:0] a;
  input [63:0] b;
  wire [63:0] b;
  wire [7:0] co_11;
  wire [7:0] co_15;
  wire [7:0] co_19;
  wire [7:0] co_23;
  wire [7:0] co_27;
  wire [7:0] co_3;
  wire [7:0] co_31;
  wire [7:0] co_7;
  wire [7:0] luts_O5_0;
  wire [7:0] luts_O5_12;
  wire [7:0] luts_O5_16;
  wire [7:0] luts_O5_20;
  wire [7:0] luts_O5_24;
  wire [7:0] luts_O5_28;
  wire [7:0] luts_O5_4;
  wire [7:0] luts_O5_8;
  wire [7:0] luts_O6_1;
  wire [7:0] luts_O6_13;
  wire [7:0] luts_O6_17;
  wire [7:0] luts_O6_21;
  wire [7:0] luts_O6_25;
  wire [7:0] luts_O6_29;
  wire [7:0] luts_O6_5;
  wire [7:0] luts_O6_9;
  wire [7:0] o_10;
  wire [7:0] o_14;
  wire [7:0] o_18;
  wire [7:0] o_2;
  wire [7:0] o_22;
  wire [7:0] o_26;
  wire [7:0] o_30;
  wire [7:0] o_6;
  output [63:0] out0;
  wire [63:0] out0;
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) A_LUT_0 (
    .I0(a[0]),
    .I1(b[0]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_0[0]),
    .O6(luts_O6_1[0])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) A_LUT_18 (
    .I0(a[16]),
    .I1(b[16]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_8[0]),
    .O6(luts_O6_9[0])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) A_LUT_27 (
    .I0(a[24]),
    .I1(b[24]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_12[0]),
    .O6(luts_O6_13[0])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) A_LUT_36 (
    .I0(a[32]),
    .I1(b[32]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_16[0]),
    .O6(luts_O6_17[0])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) A_LUT_45 (
    .I0(a[40]),
    .I1(b[40]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_20[0]),
    .O6(luts_O6_21[0])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) A_LUT_54 (
    .I0(a[48]),
    .I1(b[48]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_24[0]),
    .O6(luts_O6_25[0])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) A_LUT_63 (
    .I0(a[56]),
    .I1(b[56]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_28[0]),
    .O6(luts_O6_29[0])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) A_LUT_9 (
    .I0(a[8]),
    .I1(b[8]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_4[0]),
    .O6(luts_O6_5[0])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) B_LUT_1 (
    .I0(a[1]),
    .I1(b[1]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_0[1]),
    .O6(luts_O6_1[1])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) B_LUT_10 (
    .I0(a[9]),
    .I1(b[9]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_4[1]),
    .O6(luts_O6_5[1])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) B_LUT_19 (
    .I0(a[17]),
    .I1(b[17]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_8[1]),
    .O6(luts_O6_9[1])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) B_LUT_28 (
    .I0(a[25]),
    .I1(b[25]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_12[1]),
    .O6(luts_O6_13[1])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) B_LUT_37 (
    .I0(a[33]),
    .I1(b[33]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_16[1]),
    .O6(luts_O6_17[1])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) B_LUT_46 (
    .I0(a[41]),
    .I1(b[41]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_20[1]),
    .O6(luts_O6_21[1])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) B_LUT_55 (
    .I0(a[49]),
    .I1(b[49]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_24[1]),
    .O6(luts_O6_25[1])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) B_LUT_64 (
    .I0(a[57]),
    .I1(b[57]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_28[1]),
    .O6(luts_O6_29[1])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) C_LUT_11 (
    .I0(a[10]),
    .I1(b[10]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_4[2]),
    .O6(luts_O6_5[2])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) C_LUT_2 (
    .I0(a[2]),
    .I1(b[2]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_0[2]),
    .O6(luts_O6_1[2])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) C_LUT_20 (
    .I0(a[18]),
    .I1(b[18]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_8[2]),
    .O6(luts_O6_9[2])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) C_LUT_29 (
    .I0(a[26]),
    .I1(b[26]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_12[2]),
    .O6(luts_O6_13[2])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) C_LUT_38 (
    .I0(a[34]),
    .I1(b[34]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_16[2]),
    .O6(luts_O6_17[2])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) C_LUT_47 (
    .I0(a[42]),
    .I1(b[42]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_20[2]),
    .O6(luts_O6_21[2])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) C_LUT_56 (
    .I0(a[50]),
    .I1(b[50]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_24[2]),
    .O6(luts_O6_25[2])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) C_LUT_65 (
    .I0(a[58]),
    .I1(b[58]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_28[2]),
    .O6(luts_O6_29[2])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) D_LUT_12 (
    .I0(a[11]),
    .I1(b[11]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_4[3]),
    .O6(luts_O6_5[3])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) D_LUT_21 (
    .I0(a[19]),
    .I1(b[19]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_8[3]),
    .O6(luts_O6_9[3])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) D_LUT_3 (
    .I0(a[3]),
    .I1(b[3]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_0[3]),
    .O6(luts_O6_1[3])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) D_LUT_30 (
    .I0(a[27]),
    .I1(b[27]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_12[3]),
    .O6(luts_O6_13[3])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) D_LUT_39 (
    .I0(a[35]),
    .I1(b[35]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_16[3]),
    .O6(luts_O6_17[3])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) D_LUT_48 (
    .I0(a[43]),
    .I1(b[43]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_20[3]),
    .O6(luts_O6_21[3])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) D_LUT_57 (
    .I0(a[51]),
    .I1(b[51]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_24[3]),
    .O6(luts_O6_25[3])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) D_LUT_66 (
    .I0(a[59]),
    .I1(b[59]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_28[3]),
    .O6(luts_O6_29[3])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) E_LUT_13 (
    .I0(a[12]),
    .I1(b[12]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_4[4]),
    .O6(luts_O6_5[4])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) E_LUT_22 (
    .I0(a[20]),
    .I1(b[20]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_8[4]),
    .O6(luts_O6_9[4])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) E_LUT_31 (
    .I0(a[28]),
    .I1(b[28]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_12[4]),
    .O6(luts_O6_13[4])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) E_LUT_4 (
    .I0(a[4]),
    .I1(b[4]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_0[4]),
    .O6(luts_O6_1[4])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) E_LUT_40 (
    .I0(a[36]),
    .I1(b[36]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_16[4]),
    .O6(luts_O6_17[4])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) E_LUT_49 (
    .I0(a[44]),
    .I1(b[44]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_20[4]),
    .O6(luts_O6_21[4])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) E_LUT_58 (
    .I0(a[52]),
    .I1(b[52]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_24[4]),
    .O6(luts_O6_25[4])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) E_LUT_67 (
    .I0(a[60]),
    .I1(b[60]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_28[4]),
    .O6(luts_O6_29[4])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) F_LUT_14 (
    .I0(a[13]),
    .I1(b[13]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_4[5]),
    .O6(luts_O6_5[5])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) F_LUT_23 (
    .I0(a[21]),
    .I1(b[21]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_8[5]),
    .O6(luts_O6_9[5])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) F_LUT_32 (
    .I0(a[29]),
    .I1(b[29]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_12[5]),
    .O6(luts_O6_13[5])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) F_LUT_41 (
    .I0(a[37]),
    .I1(b[37]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_16[5]),
    .O6(luts_O6_17[5])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) F_LUT_5 (
    .I0(a[5]),
    .I1(b[5]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_0[5]),
    .O6(luts_O6_1[5])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) F_LUT_50 (
    .I0(a[45]),
    .I1(b[45]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_20[5]),
    .O6(luts_O6_21[5])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) F_LUT_59 (
    .I0(a[53]),
    .I1(b[53]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_24[5]),
    .O6(luts_O6_25[5])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) F_LUT_68 (
    .I0(a[61]),
    .I1(b[61]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_28[5]),
    .O6(luts_O6_29[5])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) G_LUT_15 (
    .I0(a[14]),
    .I1(b[14]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_4[6]),
    .O6(luts_O6_5[6])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) G_LUT_24 (
    .I0(a[22]),
    .I1(b[22]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_8[6]),
    .O6(luts_O6_9[6])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) G_LUT_33 (
    .I0(a[30]),
    .I1(b[30]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_12[6]),
    .O6(luts_O6_13[6])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) G_LUT_42 (
    .I0(a[38]),
    .I1(b[38]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_16[6]),
    .O6(luts_O6_17[6])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) G_LUT_51 (
    .I0(a[46]),
    .I1(b[46]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_20[6]),
    .O6(luts_O6_21[6])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) G_LUT_6 (
    .I0(a[6]),
    .I1(b[6]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_0[6]),
    .O6(luts_O6_1[6])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) G_LUT_60 (
    .I0(a[54]),
    .I1(b[54]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_24[6]),
    .O6(luts_O6_25[6])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) G_LUT_69 (
    .I0(a[62]),
    .I1(b[62]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_28[6]),
    .O6(luts_O6_29[6])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) H_LUT_16 (
    .I0(a[15]),
    .I1(b[15]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_4[7]),
    .O6(luts_O6_5[7])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) H_LUT_25 (
    .I0(a[23]),
    .I1(b[23]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_8[7]),
    .O6(luts_O6_9[7])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) H_LUT_34 (
    .I0(a[31]),
    .I1(b[31]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_12[7]),
    .O6(luts_O6_13[7])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) H_LUT_43 (
    .I0(a[39]),
    .I1(b[39]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_16[7]),
    .O6(luts_O6_17[7])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) H_LUT_52 (
    .I0(a[47]),
    .I1(b[47]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_20[7]),
    .O6(luts_O6_21[7])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) H_LUT_61 (
    .I0(a[55]),
    .I1(b[55]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_24[7]),
    .O6(luts_O6_25[7])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) H_LUT_7 (
    .I0(a[7]),
    .I1(b[7]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_0[7]),
    .O6(luts_O6_1[7])
  );
  LUT6_2 #(
    .INIT(64'h6000000080000000)
  ) H_LUT_70 (
    .I0(a[63]),
    .I1(b[63]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_28[7]),
    .O6(luts_O6_29[7])
  );
  CARRY8 carry_17 (
    .CI(co_3[7]),
    .CI_TOP(1'h0),
    .CO(co_7),
    .DI(luts_O5_4),
    .O(out0[15:8]),
    .S(luts_O6_5)
  );
  CARRY8 carry_26 (
    .CI(co_7[7]),
    .CI_TOP(1'h0),
    .CO(co_11),
    .DI(luts_O5_8),
    .O(out0[23:16]),
    .S(luts_O6_9)
  );
  CARRY8 carry_35 (
    .CI(co_11[7]),
    .CI_TOP(1'h0),
    .CO(co_15),
    .DI(luts_O5_12),
    .O(out0[31:24]),
    .S(luts_O6_13)
  );
  CARRY8 carry_44 (
    .CI(co_15[7]),
    .CI_TOP(1'h0),
    .CO(co_19),
    .DI(luts_O5_16),
    .O(out0[39:32]),
    .S(luts_O6_17)
  );
  CARRY8 carry_53 (
    .CI(co_19[7]),
    .CI_TOP(1'h0),
    .CO(co_23),
    .DI(luts_O5_20),
    .O(out0[47:40]),
    .S(luts_O6_21)
  );
  CARRY8 carry_62 (
    .CI(co_23[7]),
    .CI_TOP(1'h0),
    .CO(co_27),
    .DI(luts_O5_24),
    .O(out0[55:48]),
    .S(luts_O6_25)
  );
  CARRY8 carry_71 (
    .CI(co_27[7]),
    .CI_TOP(1'h0),
    .CO(co_31),
    .DI(luts_O5_28),
    .O(out0[63:56]),
    .S(luts_O6_29)
  );
  CARRY8 carry_8 (
    .CI(1'h0),
    .CI_TOP(1'h0),
    .CO(co_3),
    .DI(luts_O5_0),
    .O(out0[7:0]),
    .S(luts_O6_1)
  );
  assign o_10[7] = out0[23];
  assign o_10[6] = out0[22];
  assign o_10[5] = out0[21];
  assign o_10[4] = out0[20];
  assign o_10[3] = out0[19];
  assign o_10[2] = out0[18];
  assign o_10[1] = out0[17];
  assign o_10[0] = out0[16];
  assign o_14[7] = out0[31];
  assign o_14[6] = out0[30];
  assign o_14[5] = out0[29];
  assign o_14[4] = out0[28];
  assign o_14[3] = out0[27];
  assign o_14[2] = out0[26];
  assign o_14[1] = out0[25];
  assign o_14[0] = out0[24];
  assign o_18[7] = out0[39];
  assign o_18[6] = out0[38];
  assign o_18[5] = out0[37];
  assign o_18[4] = out0[36];
  assign o_18[3] = out0[35];
  assign o_18[2] = out0[34];
  assign o_18[1] = out0[33];
  assign o_18[0] = out0[32];
  assign o_2[7] = out0[7];
  assign o_2[6] = out0[6];
  assign o_2[5] = out0[5];
  assign o_2[4] = out0[4];
  assign o_2[3] = out0[3];
  assign o_2[2] = out0[2];
  assign o_2[1] = out0[1];
  assign o_2[0] = out0[0];
  assign o_22[7] = out0[47];
  assign o_22[6] = out0[46];
  assign o_22[5] = out0[45];
  assign o_22[4] = out0[44];
  assign o_22[3] = out0[43];
  assign o_22[2] = out0[42];
  assign o_22[1] = out0[41];
  assign o_22[0] = out0[40];
  assign o_26[7] = out0[55];
  assign o_26[6] = out0[54];
  assign o_26[5] = out0[53];
  assign o_26[4] = out0[52];
  assign o_26[3] = out0[51];
  assign o_26[2] = out0[50];
  assign o_26[1] = out0[49];
  assign o_26[0] = out0[48];
  assign o_30[7] = out0[63];
  assign o_30[6] = out0[62];
  assign o_30[5] = out0[61];
  assign o_30[4] = out0[60];
  assign o_30[3] = out0[59];
  assign o_30[2] = out0[58];
  assign o_30[1] = out0[57];
  assign o_30[0] = out0[56];
  assign o_6[7] = out0[15];
  assign o_6[6] = out0[14];
  assign o_6[5] = out0[13];
  assign o_6[4] = out0[12];
  assign o_6[3] = out0[11];
  assign o_6[2] = out0[10];
  assign o_6[1] = out0[9];
  assign o_6[0] = out0[8];
endmodule

