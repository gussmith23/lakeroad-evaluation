/* Generated by Yosys 0.15+50 (git sha1 6318db615, x86_64-apple-darwin20.2-clang 10.0.0-4ubuntu1 -fPIC -Os) */

module lakeroad_xilinx_ultrascale_plus_eq32_2(a, b, out0);
  input [31:0] a;
  wire [31:0] a;
  input [31:0] b;
  wire [31:0] b;
  wire [7:0] co_11;
  wire [7:0] co_15;
  wire [7:0] co_19;
  wire [7:0] co_23;
  wire [7:0] co_27;
  wire [7:0] co_3;
  wire [7:0] co_31;
  wire [7:0] co_35;
  wire [7:0] co_39;
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
  wire [7:0] luts_O5_8;
  wire [7:0] luts_O6_1;
  wire [7:0] luts_O6_13;
  wire [7:0] luts_O6_17;
  wire [7:0] luts_O6_21;
  wire [7:0] luts_O6_25;
  wire [7:0] luts_O6_29;
  wire [7:0] luts_O6_33;
  wire [7:0] luts_O6_37;
  wire [7:0] luts_O6_5;
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
  wire [7:0] o_6;
  output out0;
  wire out0;
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
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
    .INIT(64'h9fffffff9fffffff)
  ) A_LUT_18 (
    .I0(a[8]),
    .I1(b[8]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_8[0]),
    .O6(luts_O6_9[0])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) A_LUT_27 (
    .I0(a[0]),
    .I1(b[0]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_12[0]),
    .O6(luts_O6_13[0])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) A_LUT_36 (
    .I0(a[8]),
    .I1(b[8]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_16[0]),
    .O6(luts_O6_17[0])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) A_LUT_45 (
    .I0(a[16]),
    .I1(b[16]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_20[0]),
    .O6(luts_O6_21[0])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) A_LUT_54 (
    .I0(a[0]),
    .I1(b[0]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_24[0]),
    .O6(luts_O6_25[0])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) A_LUT_63 (
    .I0(a[8]),
    .I1(b[8]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_28[0]),
    .O6(luts_O6_29[0])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) A_LUT_72 (
    .I0(a[16]),
    .I1(b[16]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_32[0]),
    .O6(luts_O6_33[0])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) A_LUT_81 (
    .I0(a[24]),
    .I1(b[24]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_36[0]),
    .O6(luts_O6_37[0])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) A_LUT_9 (
    .I0(a[0]),
    .I1(b[0]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_4[0]),
    .O6(luts_O6_5[0])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
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
    .INIT(64'h9fffffff9fffffff)
  ) B_LUT_10 (
    .I0(a[1]),
    .I1(b[1]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_4[1]),
    .O6(luts_O6_5[1])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) B_LUT_19 (
    .I0(a[9]),
    .I1(b[9]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_8[1]),
    .O6(luts_O6_9[1])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) B_LUT_28 (
    .I0(a[1]),
    .I1(b[1]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_12[1]),
    .O6(luts_O6_13[1])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) B_LUT_37 (
    .I0(a[9]),
    .I1(b[9]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_16[1]),
    .O6(luts_O6_17[1])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) B_LUT_46 (
    .I0(a[17]),
    .I1(b[17]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_20[1]),
    .O6(luts_O6_21[1])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) B_LUT_55 (
    .I0(a[1]),
    .I1(b[1]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_24[1]),
    .O6(luts_O6_25[1])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) B_LUT_64 (
    .I0(a[9]),
    .I1(b[9]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_28[1]),
    .O6(luts_O6_29[1])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) B_LUT_73 (
    .I0(a[17]),
    .I1(b[17]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_32[1]),
    .O6(luts_O6_33[1])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) B_LUT_82 (
    .I0(a[25]),
    .I1(b[25]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_36[1]),
    .O6(luts_O6_37[1])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) C_LUT_11 (
    .I0(a[2]),
    .I1(b[2]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_4[2]),
    .O6(luts_O6_5[2])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
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
    .INIT(64'h9fffffff9fffffff)
  ) C_LUT_20 (
    .I0(a[10]),
    .I1(b[10]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_8[2]),
    .O6(luts_O6_9[2])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) C_LUT_29 (
    .I0(a[2]),
    .I1(b[2]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_12[2]),
    .O6(luts_O6_13[2])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) C_LUT_38 (
    .I0(a[10]),
    .I1(b[10]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_16[2]),
    .O6(luts_O6_17[2])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) C_LUT_47 (
    .I0(a[18]),
    .I1(b[18]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_20[2]),
    .O6(luts_O6_21[2])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) C_LUT_56 (
    .I0(a[2]),
    .I1(b[2]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_24[2]),
    .O6(luts_O6_25[2])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) C_LUT_65 (
    .I0(a[10]),
    .I1(b[10]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_28[2]),
    .O6(luts_O6_29[2])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) C_LUT_74 (
    .I0(a[18]),
    .I1(b[18]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_32[2]),
    .O6(luts_O6_33[2])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) C_LUT_83 (
    .I0(a[26]),
    .I1(b[26]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_36[2]),
    .O6(luts_O6_37[2])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) D_LUT_12 (
    .I0(a[3]),
    .I1(b[3]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_4[3]),
    .O6(luts_O6_5[3])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) D_LUT_21 (
    .I0(a[11]),
    .I1(b[11]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_8[3]),
    .O6(luts_O6_9[3])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
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
    .INIT(64'h9fffffff9fffffff)
  ) D_LUT_30 (
    .I0(a[3]),
    .I1(b[3]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_12[3]),
    .O6(luts_O6_13[3])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) D_LUT_39 (
    .I0(a[11]),
    .I1(b[11]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_16[3]),
    .O6(luts_O6_17[3])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) D_LUT_48 (
    .I0(a[19]),
    .I1(b[19]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_20[3]),
    .O6(luts_O6_21[3])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) D_LUT_57 (
    .I0(a[3]),
    .I1(b[3]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_24[3]),
    .O6(luts_O6_25[3])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) D_LUT_66 (
    .I0(a[11]),
    .I1(b[11]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_28[3]),
    .O6(luts_O6_29[3])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) D_LUT_75 (
    .I0(a[19]),
    .I1(b[19]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_32[3]),
    .O6(luts_O6_33[3])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) D_LUT_84 (
    .I0(a[27]),
    .I1(b[27]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_36[3]),
    .O6(luts_O6_37[3])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) E_LUT_13 (
    .I0(a[4]),
    .I1(b[4]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_4[4]),
    .O6(luts_O6_5[4])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) E_LUT_22 (
    .I0(a[12]),
    .I1(b[12]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_8[4]),
    .O6(luts_O6_9[4])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) E_LUT_31 (
    .I0(a[4]),
    .I1(b[4]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_12[4]),
    .O6(luts_O6_13[4])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
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
    .INIT(64'h9fffffff9fffffff)
  ) E_LUT_40 (
    .I0(a[12]),
    .I1(b[12]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_16[4]),
    .O6(luts_O6_17[4])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) E_LUT_49 (
    .I0(a[20]),
    .I1(b[20]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_20[4]),
    .O6(luts_O6_21[4])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) E_LUT_58 (
    .I0(a[4]),
    .I1(b[4]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_24[4]),
    .O6(luts_O6_25[4])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) E_LUT_67 (
    .I0(a[12]),
    .I1(b[12]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_28[4]),
    .O6(luts_O6_29[4])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) E_LUT_76 (
    .I0(a[20]),
    .I1(b[20]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_32[4]),
    .O6(luts_O6_33[4])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) E_LUT_85 (
    .I0(a[28]),
    .I1(b[28]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_36[4]),
    .O6(luts_O6_37[4])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) F_LUT_14 (
    .I0(a[5]),
    .I1(b[5]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_4[5]),
    .O6(luts_O6_5[5])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) F_LUT_23 (
    .I0(a[13]),
    .I1(b[13]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_8[5]),
    .O6(luts_O6_9[5])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) F_LUT_32 (
    .I0(a[5]),
    .I1(b[5]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_12[5]),
    .O6(luts_O6_13[5])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) F_LUT_41 (
    .I0(a[13]),
    .I1(b[13]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_16[5]),
    .O6(luts_O6_17[5])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
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
    .INIT(64'h9fffffff9fffffff)
  ) F_LUT_50 (
    .I0(a[21]),
    .I1(b[21]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_20[5]),
    .O6(luts_O6_21[5])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) F_LUT_59 (
    .I0(a[5]),
    .I1(b[5]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_24[5]),
    .O6(luts_O6_25[5])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) F_LUT_68 (
    .I0(a[13]),
    .I1(b[13]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_28[5]),
    .O6(luts_O6_29[5])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) F_LUT_77 (
    .I0(a[21]),
    .I1(b[21]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_32[5]),
    .O6(luts_O6_33[5])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) F_LUT_86 (
    .I0(a[29]),
    .I1(b[29]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_36[5]),
    .O6(luts_O6_37[5])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) G_LUT_15 (
    .I0(a[6]),
    .I1(b[6]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_4[6]),
    .O6(luts_O6_5[6])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) G_LUT_24 (
    .I0(a[14]),
    .I1(b[14]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_8[6]),
    .O6(luts_O6_9[6])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) G_LUT_33 (
    .I0(a[6]),
    .I1(b[6]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_12[6]),
    .O6(luts_O6_13[6])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) G_LUT_42 (
    .I0(a[14]),
    .I1(b[14]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_16[6]),
    .O6(luts_O6_17[6])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) G_LUT_51 (
    .I0(a[22]),
    .I1(b[22]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_20[6]),
    .O6(luts_O6_21[6])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
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
    .INIT(64'h9fffffff9fffffff)
  ) G_LUT_60 (
    .I0(a[6]),
    .I1(b[6]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_24[6]),
    .O6(luts_O6_25[6])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) G_LUT_69 (
    .I0(a[14]),
    .I1(b[14]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_28[6]),
    .O6(luts_O6_29[6])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) G_LUT_78 (
    .I0(a[22]),
    .I1(b[22]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_32[6]),
    .O6(luts_O6_33[6])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) G_LUT_87 (
    .I0(a[30]),
    .I1(b[30]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_36[6]),
    .O6(luts_O6_37[6])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) H_LUT_16 (
    .I0(a[7]),
    .I1(b[7]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_4[7]),
    .O6(luts_O6_5[7])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) H_LUT_25 (
    .I0(a[15]),
    .I1(b[15]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_8[7]),
    .O6(luts_O6_9[7])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) H_LUT_34 (
    .I0(a[7]),
    .I1(b[7]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_12[7]),
    .O6(luts_O6_13[7])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) H_LUT_43 (
    .I0(a[15]),
    .I1(b[15]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_16[7]),
    .O6(luts_O6_17[7])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) H_LUT_52 (
    .I0(a[23]),
    .I1(b[23]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_20[7]),
    .O6(luts_O6_21[7])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) H_LUT_61 (
    .I0(a[7]),
    .I1(b[7]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_24[7]),
    .O6(luts_O6_25[7])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
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
    .INIT(64'h9fffffff9fffffff)
  ) H_LUT_70 (
    .I0(a[15]),
    .I1(b[15]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_28[7]),
    .O6(luts_O6_29[7])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) H_LUT_79 (
    .I0(a[23]),
    .I1(b[23]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_32[7]),
    .O6(luts_O6_33[7])
  );
  LUT6_2 #(
    .INIT(64'h9fffffff9fffffff)
  ) H_LUT_88 (
    .I0(a[31]),
    .I1(b[31]),
    .I2(1'h1),
    .I3(1'h1),
    .I4(1'h1),
    .I5(1'h1),
    .O5(luts_O5_36[7]),
    .O6(luts_O6_37[7])
  );
  CARRY8 carry_17 (
    .CI(1'h1),
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
    .CI(1'h1),
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
    .CI(1'h1),
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
    .CI(1'h1),
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
    .CO({ out0, co_39[6:0] }),
    .DI(luts_O5_36),
    .O(o_38),
    .S(luts_O6_37)
  );
  assign co_39[7] = out0;
endmodule
