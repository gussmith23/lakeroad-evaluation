Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:13:32 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//no-matches.futil-ultrascale-timing-synth.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack:                    inf
  Source:                 tcam/pd37/out_reg[0]/C
                            (rising edge-triggered cell FDRE)
  Destination:            tcam/me15/r/out_reg[0]/D
  Path Group:             (none)
  Path Type:              Max at Slow Process Corner
  Data Path Delay:        3.906ns  (logic 1.268ns (32.463%)  route 2.638ns (67.537%))
  Logic Levels:           16  (CARRY8=5 FDRE=1 LUT4=3 LUT5=6 LUT6=1)

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         FDRE                         0.000     0.000 r  tcam/pd37/out_reg[0]/C
                         FDRE (Prop_FDRE_C_Q)         0.093     0.093 r  tcam/pd37/out_reg[0]/Q
                         net (fo=12, unplaced)        0.145     0.238    tcam/pd37/pd37_out
                         LUT4 (Prop_LUT4_I0_O)        0.116     0.354 f  tcam/pd37/A_LUT_0_i_11__0/O
                         net (fo=1, unplaced)         0.210     0.564    tcam/pd49/A_LUT_0_i_4__31_0
                         LUT5 (Prop_LUT5_I4_O)        0.040     0.604 f  tcam/pd49/A_LUT_0_i_6__0/O
                         net (fo=1, unplaced)         0.161     0.765    tcam/pd49/A_LUT_0_i_6__0_n_0
                         LUT4 (Prop_LUT4_I0_O)        0.116     0.881 r  tcam/pd49/A_LUT_0_i_4__31/O
                         net (fo=69, unplaced)        0.287     1.168    tcam/fsm32/A_LUT_0
                         LUT5 (Prop_LUT5_I0_O)        0.040     1.208 r  tcam/fsm32/A_LUT_0_i_5__0/O
                         net (fo=78, unplaced)        0.290     1.498    tcam/fsm32/out_reg[3]_6
                         LUT4 (Prop_LUT4_I0_O)        0.085     1.583 f  tcam/fsm32/C_LUT_2_i_1__29/O
                         net (fo=2, unplaced)         0.210     1.793    tcam/me15/sub/_impl/C_LUT_2/I1
                         LUT5 (Prop_LUT5_I1_O)        0.084     1.877 r  tcam/me15/sub/_impl/C_LUT_2/LUT5/O
                         net (fo=1, unplaced)         0.280     2.157    tcam/me15/sub/_impl/luts_O5_0[2]
                         CARRY8 (Prop_CARRY8_DI[2]_O[4])
                                                      0.189     2.346 r  tcam/me15/sub/_impl/carry_8/O[4]
                         net (fo=38, unplaced)        0.273     2.619    tcam/me15/sub/_impl/out0[0]
                         LUT5 (Prop_LUT5_I1_O)        0.085     2.704 r  tcam/me15/sub/_impl/B_LUT_1_i_4__4/O
                         net (fo=7, unplaced)         0.235     2.939    tcam/me15/sub/_impl/B_LUT_1_i_4__4_n_0
                         LUT6 (Prop_LUT6_I2_O)        0.040     2.979 r  tcam/me15/sub/_impl/B_LUT_1_i_2__14/O
                         net (fo=2, unplaced)         0.210     3.189    tcam/me15/eq/_impl/B_LUT_1/I1
                         LUT5 (Prop_LUT5_I1_O)        0.089     3.278 r  tcam/me15/eq/_impl/B_LUT_1/LUT5/O
                         net (fo=1, unplaced)         0.234     3.512    tcam/me15/eq/_impl/luts_O5_0[1]
                         CARRY8 (Prop_CARRY8_DI[1]_CO[7])
                                                      0.161     3.673 r  tcam/me15/eq/_impl/carry_8/CO[7]
                         net (fo=1, unplaced)         0.007     3.680    tcam/me15/eq/_impl/co_3[7]
                         CARRY8 (Prop_CARRY8_CI_CO[7])
                                                      0.030     3.710 r  tcam/me15/eq/_impl/carry_17/CO[7]
                         net (fo=1, unplaced)         0.007     3.717    tcam/me15/eq/_impl/co_7[7]
                         CARRY8 (Prop_CARRY8_CI_CO[7])
                                                      0.030     3.747 r  tcam/me15/eq/_impl/carry_26/CO[7]
                         net (fo=1, unplaced)         0.007     3.754    tcam/me15/eq/_impl/co_11[7]
                         CARRY8 (Prop_CARRY8_CI_CO[7])
                                                      0.030     3.784 r  tcam/me15/eq/_impl/carry_35/CO[7]
                         net (fo=1, unplaced)         0.024     3.808    tcam/me15/r/out0
                         LUT5 (Prop_LUT5_I0_O)        0.040     3.848 r  tcam/me15/r/out[0]_i_1__14/O
                         net (fo=1, unplaced)         0.058     3.906    tcam/me15/r/out[0]_i_1__14_n_0
                         FDRE                                         r  tcam/me15/r/out_reg[0]/D
  -------------------------------------------------------------------    -------------------




