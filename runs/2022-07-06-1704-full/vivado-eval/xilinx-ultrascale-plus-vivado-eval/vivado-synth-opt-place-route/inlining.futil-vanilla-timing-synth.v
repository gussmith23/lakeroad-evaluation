Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 02:27:34 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//inlining.futil-vanilla-timing-synth.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack:                    inf
  Source:                 fsm2/out_reg[0]/C
                            (rising edge-triggered cell FDRE)
  Destination:            mul_out/out_reg[31]/D
  Path Group:             (none)
  Path Type:              Max at Slow Process Corner
  Data Path Delay:        5.304ns  (logic 3.776ns (71.192%)  route 1.528ns (28.808%))
  Logic Levels:           16  (CARRY8=2 DSP_A_B_DATA=1 DSP_ALU=2 DSP_M_DATA=1 DSP_MULTIPLIER=1 DSP_OUTPUT=2 DSP_PREADD_DATA=1 FDRE=1 LUT2=1 LUT3=1 LUT4=1 LUT6=2)

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         FDRE                         0.000     0.000 r  fsm2/out_reg[0]/C
                         FDRE (Prop_FDRE_C_Q)         0.093     0.093 f  fsm2/out_reg[0]/Q
                         net (fo=19, unplaced)        0.225     0.318    fsm2/fsm2_out[0]
                         LUT6 (Prop_LUT6_I0_O)        0.179     0.497 f  fsm2/out[1]_i_3/O
                         net (fo=7, unplaced)         0.235     0.732    fsm1/out_reg[0]_4
                         LUT4 (Prop_LUT4_I3_O)        0.085     0.817 r  fsm1/out[31]_i_3/O
                         net (fo=9, unplaced)         0.190     1.007    mul_out/out_reg[31]_0
                         LUT6 (Prop_LUT6_I2_O)        0.100     1.107 f  mul_out/out[31]_i_1__2/O
                         net (fo=127, unplaced)       0.301     1.408    left_1_0/do_mul_go_in
                         LUT2 (Prop_LUT2_I1_O)        0.085     1.493 f  left_1_0/out_i_1__10/O
                         net (fo=2, unplaced)         0.257     1.750    mult0/out__0/B[16]
                         DSP_A_B_DATA (Prop_DSP_A_B_DATA_B[16]_B2_DATA[16])
                                                      0.195     1.945 r  mult0/out__0/DSP_A_B_DATA_INST/B2_DATA[16]
                         net (fo=1, unplaced)         0.000     1.945    mult0/out__0/DSP_A_B_DATA.B2_DATA<16>
                         DSP_PREADD_DATA (Prop_DSP_PREADD_DATA_B2_DATA[16]_B2B1[16])
                                                      0.092     2.037 r  mult0/out__0/DSP_PREADD_DATA_INST/B2B1[16]
                         net (fo=1, unplaced)         0.000     2.037    mult0/out__0/DSP_PREADD_DATA.B2B1<16>
                         DSP_MULTIPLIER (Prop_DSP_MULTIPLIER_B2B1[16]_U[43])
                                                      0.737     2.774 f  mult0/out__0/DSP_MULTIPLIER_INST/U[43]
                         net (fo=1, unplaced)         0.000     2.774    mult0/out__0/DSP_MULTIPLIER.U<43>
                         DSP_M_DATA (Prop_DSP_M_DATA_U[43]_U_DATA[43])
                                                      0.059     2.833 r  mult0/out__0/DSP_M_DATA_INST/U_DATA[43]
                         net (fo=1, unplaced)         0.000     2.833    mult0/out__0/DSP_M_DATA.U_DATA<43>
                         DSP_ALU (Prop_DSP_ALU_U_DATA[43]_ALU_OUT[47])
                                                      0.699     3.532 f  mult0/out__0/DSP_ALU_INST/ALU_OUT[47]
                         net (fo=1, unplaced)         0.000     3.532    mult0/out__0/DSP_ALU.ALU_OUT<47>
                         DSP_OUTPUT (Prop_DSP_OUTPUT_ALU_OUT[47]_PCOUT[47])
                                                      0.159     3.691 r  mult0/out__0/DSP_OUTPUT_INST/PCOUT[47]
                         net (fo=1, unplaced)         0.016     3.707    mult0/out__0__0/PCIN[47]
                         DSP_ALU (Prop_DSP_ALU_PCIN[47]_ALU_OUT[0])
                                                      0.698     4.405 f  mult0/out__0__0/DSP_ALU_INST/ALU_OUT[0]
                         net (fo=1, unplaced)         0.000     4.405    mult0/out__0__0/DSP_ALU.ALU_OUT<0>
                         DSP_OUTPUT (Prop_DSP_OUTPUT_ALU_OUT[0]_P[0])
                                                      0.141     4.546 r  mult0/out__0__0/DSP_OUTPUT_INST/P[0]
                         net (fo=1, unplaced)         0.241     4.787    mult0/out__0__0_n_105
                         LUT3 (Prop_LUT3_I1_O)        0.063     4.850 r  mult0/out[23]_i_15/O
                         net (fo=1, unplaced)         0.025     4.875    mult0/out[23]_i_15_n_0
                         CARRY8 (Prop_CARRY8_S[1]_CO[7])
                                                      0.245     5.120 r  mult0/out_reg[23]_i_1/CO[7]
                         net (fo=1, unplaced)         0.007     5.127    mult0/out_reg[23]_i_1_n_0
                         CARRY8 (Prop_CARRY8_CI_O[7])
                                                      0.146     5.273 r  mult0/out_reg[31]_i_2/O[7]
                         net (fo=1, unplaced)         0.031     5.304    mul_out/out[15]
                         FDRE                                         r  mul_out/out_reg[31]/D
  -------------------------------------------------------------------    -------------------




