/* Generated by Yosys 0.19 (git sha1 a45c131b37c, clang 13.1.6 -fPIC -Os) */

module lakeroad_xilinx_ultrascale_plus_ult128_2(a, b, out0);
  input [127:0] a;
  wire [127:0] a;
  input [127:0] b;
  wire [127:0] b;
  wire [7:0] co_11;
  wire [7:0] co_15;
  wire [7:0] co_19;
  wire [7:0] co_23;
  wire [7:0] co_27;
  wire [7:0] co_3;
  wire [7:0] co_31;
  wire [7:0] co_35;
  wire [7:0] co_39;
  wire [7:0] co_43;
  wire [7:0] co_47;
  wire [7:0] co_51;
  wire [7:0] co_55;
  wire [7:0] co_59;
  wire [7:0] co_63;
  wire [7:0] co_7;
  wire [7:0] luts_O5_0;
  wire [7:0] luts_O5_12;
  wire [7:0] luts_O5_16;
  wire [7:0] luts_O5_20;
  wire [7:0] luts_O5_24;
  wire [7:0] luts_O5_28;
  wire [7:0] luts_O5_32;
  wire [7:0] luts_O5_36;
  wire [7:0] luts_O5_4;
  wire [7:0] luts_O5_40;
  wire [7:0] luts_O5_44;
  wire [7:0] luts_O5_48;
  wire [7:0] luts_O5_52;
  wire [7:0] luts_O5_56;
  wire [7:0] luts_O5_60;
  wire [7:0] luts_O5_8;
  wire [7:0] luts_O6_1;
  wire [7:0] luts_O6_13;
  wire [7:0] luts_O6_17;
  wire [7:0] luts_O6_21;
  wire [7:0] luts_O6_25;
  wire [7:0] luts_O6_29;
  wire [7:0] luts_O6_33;
  wire [7:0] luts_O6_37;
  wire [7:0] luts_O6_41;
  wire [7:0] luts_O6_45;
  wire [7:0] luts_O6_49;
  wire [7:0] luts_O6_5;
  wire [7:0] luts_O6_53;
  wire [7:0] luts_O6_57;
  wire [7:0] luts_O6_61;
  wire [7:0] luts_O6_9;
  wire [7:0] o_10;
  wire [7:0] o_14;
  wire [7:0] o_18;
  wire [7:0] o_2;
  wire [7:0] o_22;
  wire [7:0] o_26;
  wire [7:0] o_30;
  wire [7:0] o_34;
  wire [7:0] o_38;
  wire [7:0] o_42;
  wire [7:0] o_46;
  wire [7:0] o_50;
  wire [7:0] o_54;
  wire [7:0] o_58;
  wire [7:0] o_6;
  wire [7:0] o_62;
  output out0;
  wire out0;
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
  ) A_LUT_108 (
    .I0(a[96]),
    .I1(b[96]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_48[0]),
    .O6(luts_O6_49[0])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) A_LUT_117 (
    .I0(a[104]),
    .I1(b[104]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_52[0]),
    .O6(luts_O6_53[0])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) A_LUT_126 (
    .I0(a[112]),
    .I1(b[112]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_56[0]),
    .O6(luts_O6_57[0])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) A_LUT_135 (
    .I0(a[120]),
    .I1(b[120]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_60[0]),
    .O6(luts_O6_61[0])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
  ) A_LUT_72 (
    .I0(a[64]),
    .I1(b[64]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_32[0]),
    .O6(luts_O6_33[0])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) A_LUT_81 (
    .I0(a[72]),
    .I1(b[72]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_36[0]),
    .O6(luts_O6_37[0])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
  ) A_LUT_90 (
    .I0(a[80]),
    .I1(b[80]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_40[0]),
    .O6(luts_O6_41[0])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) A_LUT_99 (
    .I0(a[88]),
    .I1(b[88]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_44[0]),
    .O6(luts_O6_45[0])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
  ) B_LUT_100 (
    .I0(a[89]),
    .I1(b[89]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_44[1]),
    .O6(luts_O6_45[1])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) B_LUT_109 (
    .I0(a[97]),
    .I1(b[97]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_48[1]),
    .O6(luts_O6_49[1])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) B_LUT_118 (
    .I0(a[105]),
    .I1(b[105]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_52[1]),
    .O6(luts_O6_53[1])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) B_LUT_127 (
    .I0(a[113]),
    .I1(b[113]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_56[1]),
    .O6(luts_O6_57[1])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) B_LUT_136 (
    .I0(a[121]),
    .I1(b[121]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_60[1]),
    .O6(luts_O6_61[1])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
  ) B_LUT_73 (
    .I0(a[65]),
    .I1(b[65]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_32[1]),
    .O6(luts_O6_33[1])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) B_LUT_82 (
    .I0(a[73]),
    .I1(b[73]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_36[1]),
    .O6(luts_O6_37[1])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) B_LUT_91 (
    .I0(a[81]),
    .I1(b[81]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_40[1]),
    .O6(luts_O6_41[1])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) C_LUT_101 (
    .I0(a[90]),
    .I1(b[90]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_44[2]),
    .O6(luts_O6_45[2])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
  ) C_LUT_110 (
    .I0(a[98]),
    .I1(b[98]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_48[2]),
    .O6(luts_O6_49[2])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) C_LUT_119 (
    .I0(a[106]),
    .I1(b[106]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_52[2]),
    .O6(luts_O6_53[2])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) C_LUT_128 (
    .I0(a[114]),
    .I1(b[114]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_56[2]),
    .O6(luts_O6_57[2])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) C_LUT_137 (
    .I0(a[122]),
    .I1(b[122]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_60[2]),
    .O6(luts_O6_61[2])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
  ) C_LUT_74 (
    .I0(a[66]),
    .I1(b[66]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_32[2]),
    .O6(luts_O6_33[2])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) C_LUT_83 (
    .I0(a[74]),
    .I1(b[74]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_36[2]),
    .O6(luts_O6_37[2])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) C_LUT_92 (
    .I0(a[82]),
    .I1(b[82]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_40[2]),
    .O6(luts_O6_41[2])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) D_LUT_102 (
    .I0(a[91]),
    .I1(b[91]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_44[3]),
    .O6(luts_O6_45[3])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) D_LUT_111 (
    .I0(a[99]),
    .I1(b[99]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_48[3]),
    .O6(luts_O6_49[3])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
  ) D_LUT_120 (
    .I0(a[107]),
    .I1(b[107]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_52[3]),
    .O6(luts_O6_53[3])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) D_LUT_129 (
    .I0(a[115]),
    .I1(b[115]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_56[3]),
    .O6(luts_O6_57[3])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) D_LUT_138 (
    .I0(a[123]),
    .I1(b[123]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_60[3]),
    .O6(luts_O6_61[3])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
  ) D_LUT_75 (
    .I0(a[67]),
    .I1(b[67]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_32[3]),
    .O6(luts_O6_33[3])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) D_LUT_84 (
    .I0(a[75]),
    .I1(b[75]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_36[3]),
    .O6(luts_O6_37[3])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) D_LUT_93 (
    .I0(a[83]),
    .I1(b[83]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_40[3]),
    .O6(luts_O6_41[3])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) E_LUT_103 (
    .I0(a[92]),
    .I1(b[92]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_44[4]),
    .O6(luts_O6_45[4])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) E_LUT_112 (
    .I0(a[100]),
    .I1(b[100]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_48[4]),
    .O6(luts_O6_49[4])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) E_LUT_121 (
    .I0(a[108]),
    .I1(b[108]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_52[4]),
    .O6(luts_O6_53[4])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
  ) E_LUT_130 (
    .I0(a[116]),
    .I1(b[116]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_56[4]),
    .O6(luts_O6_57[4])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) E_LUT_139 (
    .I0(a[124]),
    .I1(b[124]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_60[4]),
    .O6(luts_O6_61[4])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
  ) E_LUT_76 (
    .I0(a[68]),
    .I1(b[68]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_32[4]),
    .O6(luts_O6_33[4])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) E_LUT_85 (
    .I0(a[76]),
    .I1(b[76]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_36[4]),
    .O6(luts_O6_37[4])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) E_LUT_94 (
    .I0(a[84]),
    .I1(b[84]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_40[4]),
    .O6(luts_O6_41[4])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) F_LUT_104 (
    .I0(a[93]),
    .I1(b[93]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_44[5]),
    .O6(luts_O6_45[5])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) F_LUT_113 (
    .I0(a[101]),
    .I1(b[101]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_48[5]),
    .O6(luts_O6_49[5])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) F_LUT_122 (
    .I0(a[109]),
    .I1(b[109]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_52[5]),
    .O6(luts_O6_53[5])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) F_LUT_131 (
    .I0(a[117]),
    .I1(b[117]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_56[5]),
    .O6(luts_O6_57[5])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
  ) F_LUT_140 (
    .I0(a[125]),
    .I1(b[125]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_60[5]),
    .O6(luts_O6_61[5])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
  ) F_LUT_77 (
    .I0(a[69]),
    .I1(b[69]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_32[5]),
    .O6(luts_O6_33[5])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) F_LUT_86 (
    .I0(a[77]),
    .I1(b[77]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_36[5]),
    .O6(luts_O6_37[5])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) F_LUT_95 (
    .I0(a[85]),
    .I1(b[85]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_40[5]),
    .O6(luts_O6_41[5])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) G_LUT_105 (
    .I0(a[94]),
    .I1(b[94]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_44[6]),
    .O6(luts_O6_45[6])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) G_LUT_114 (
    .I0(a[102]),
    .I1(b[102]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_48[6]),
    .O6(luts_O6_49[6])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) G_LUT_123 (
    .I0(a[110]),
    .I1(b[110]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_52[6]),
    .O6(luts_O6_53[6])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) G_LUT_132 (
    .I0(a[118]),
    .I1(b[118]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_56[6]),
    .O6(luts_O6_57[6])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) G_LUT_141 (
    .I0(a[126]),
    .I1(b[126]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_60[6]),
    .O6(luts_O6_61[6])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
  ) G_LUT_78 (
    .I0(a[70]),
    .I1(b[70]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_32[6]),
    .O6(luts_O6_33[6])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) G_LUT_87 (
    .I0(a[78]),
    .I1(b[78]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_36[6]),
    .O6(luts_O6_37[6])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) G_LUT_96 (
    .I0(a[86]),
    .I1(b[86]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_40[6]),
    .O6(luts_O6_41[6])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) H_LUT_106 (
    .I0(a[95]),
    .I1(b[95]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_44[7]),
    .O6(luts_O6_45[7])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) H_LUT_115 (
    .I0(a[103]),
    .I1(b[103]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_48[7]),
    .O6(luts_O6_49[7])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) H_LUT_124 (
    .I0(a[111]),
    .I1(b[111]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_52[7]),
    .O6(luts_O6_53[7])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) H_LUT_133 (
    .I0(a[119]),
    .I1(b[119]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_56[7]),
    .O6(luts_O6_57[7])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) H_LUT_142 (
    .I0(a[127]),
    .I1(b[127]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_60[7]),
    .O6(luts_O6_61[7])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
    .INIT(64'h9fffffffdfffffff)
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
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) H_LUT_79 (
    .I0(a[71]),
    .I1(b[71]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_32[7]),
    .O6(luts_O6_33[7])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) H_LUT_88 (
    .I0(a[79]),
    .I1(b[79]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_36[7]),
    .O6(luts_O6_37[7])
  );
  LUT6_2 #(
    .INIT(64'h9fffffffdfffffff)
  ) H_LUT_97 (
    .I0(a[87]),
    .I1(b[87]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_40[7]),
    .O6(luts_O6_41[7])
  );
  CARRY8 carry_107 (
    .CI(co_43[7]),
    .CI_TOP(1'h0),
    .CO(co_47),
    .DI(luts_O5_44),
    .O(o_46),
    .S(luts_O6_45)
  );
  CARRY8 carry_116 (
    .CI(co_47[7]),
    .CI_TOP(1'h0),
    .CO(co_51),
    .DI(luts_O5_48),
    .O(o_50),
    .S(luts_O6_49)
  );
  CARRY8 carry_125 (
    .CI(co_51[7]),
    .CI_TOP(1'h0),
    .CO(co_55),
    .DI(luts_O5_52),
    .O(o_54),
    .S(luts_O6_53)
  );
  CARRY8 carry_134 (
    .CI(co_55[7]),
    .CI_TOP(1'h0),
    .CO(co_59),
    .DI(luts_O5_56),
    .O(o_58),
    .S(luts_O6_57)
  );
  CARRY8 carry_143 (
    .CI(co_59[7]),
    .CI_TOP(1'h0),
    .CO({ out0, co_63[6:0] }),
    .DI(luts_O5_60),
    .O(o_62),
    .S(luts_O6_61)
  );
  CARRY8 carry_17 (
    .CI(co_3[7]),
    .CI_TOP(1'h0),
    .CO(co_7),
    .DI(luts_O5_4),
    .O(o_6),
    .S(luts_O6_5)
  );
  CARRY8 carry_26 (
    .CI(co_7[7]),
    .CI_TOP(1'h0),
    .CO(co_11),
    .DI(luts_O5_8),
    .O(o_10),
    .S(luts_O6_9)
  );
  CARRY8 carry_35 (
    .CI(co_11[7]),
    .CI_TOP(1'h0),
    .CO(co_15),
    .DI(luts_O5_12),
    .O(o_14),
    .S(luts_O6_13)
  );
  CARRY8 carry_44 (
    .CI(co_15[7]),
    .CI_TOP(1'h0),
    .CO(co_19),
    .DI(luts_O5_16),
    .O(o_18),
    .S(luts_O6_17)
  );
  CARRY8 carry_53 (
    .CI(co_19[7]),
    .CI_TOP(1'h0),
    .CO(co_23),
    .DI(luts_O5_20),
    .O(o_22),
    .S(luts_O6_21)
  );
  CARRY8 carry_62 (
    .CI(co_23[7]),
    .CI_TOP(1'h0),
    .CO(co_27),
    .DI(luts_O5_24),
    .O(o_26),
    .S(luts_O6_25)
  );
  CARRY8 carry_71 (
    .CI(co_27[7]),
    .CI_TOP(1'h0),
    .CO(co_31),
    .DI(luts_O5_28),
    .O(o_30),
    .S(luts_O6_29)
  );
  CARRY8 carry_8 (
    .CI(1'h0),
    .CI_TOP(1'h0),
    .CO(co_3),
    .DI(luts_O5_0),
    .O(o_2),
    .S(luts_O6_1)
  );
  CARRY8 carry_80 (
    .CI(co_31[7]),
    .CI_TOP(1'h0),
    .CO(co_35),
    .DI(luts_O5_32),
    .O(o_34),
    .S(luts_O6_33)
  );
  CARRY8 carry_89 (
    .CI(co_35[7]),
    .CI_TOP(1'h0),
    .CO(co_39),
    .DI(luts_O5_36),
    .O(o_38),
    .S(luts_O6_37)
  );
  CARRY8 carry_98 (
    .CI(co_39[7]),
    .CI_TOP(1'h0),
    .CO(co_43),
    .DI(luts_O5_40),
    .O(o_42),
    .S(luts_O6_41)
  );
  assign co_63[7] = out0;
endmodule

