Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 02:29:30 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//inlining.futil-ultrascale-timing-synth.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack:                    inf
  Source:                 fsm2/out_reg[0]/C
                            (rising edge-triggered cell FDRE)
  Destination:            mul_out2/out_reg[31]/D
  Path Group:             (none)
  Path Type:              Max at Slow Process Corner
  Data Path Delay:        5.325ns  (logic 3.776ns (70.911%)  route 1.549ns (29.089%))
  Logic Levels:           16  (CARRY8=2 DSP_A_B_DATA=1 DSP_ALU=2 DSP_M_DATA=1 DSP_MULTIPLIER=1 DSP_OUTPUT=2 DSP_PREADD_DATA=1 FDRE=1 LUT2=1 LUT3=1 LUT4=1 LUT6=2)

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         FDRE                         0.000     0.000 r  fsm2/out_reg[0]/C
                         FDRE (Prop_FDRE_C_Q)         0.093     0.093 f  fsm2/out_reg[0]/Q
                         net (fo=18, unplaced)        0.224     0.317    fsm2/fsm2_out[0]
                         LUT6 (Prop_LUT6_I0_O)        0.179     0.496 f  fsm2/A_LUT_0_i_3__1/O
                         net (fo=18, unplaced)        0.257     0.753    fsm1/out_reg[0]_2
                         LUT4 (Prop_LUT4_I0_O)        0.085     0.838 r  fsm1/out[31]_i_5/O
                         net (fo=9, unplaced)         0.190     1.028    mul_out2/out_reg[31]_0
                         LUT6 (Prop_LUT6_I1_O)        0.100     1.128 f  mul_out2/out[31]_i_1__7/O
                         net (fo=127, unplaced)       0.301     1.429    left_0_0/do_mul2_go_in
                         LUT2 (Prop_LUT2_I1_O)        0.085     1.514 f  left_0_0/out_i_1__10/O
                         net (fo=2, unplaced)         0.257     1.771    mult02/out__0/B[16]
                         DSP_A_B_DATA (Prop_DSP_A_B_DATA_B[16]_B2_DATA[16])
                                                      0.195     1.966 r  mult02/out__0/DSP_A_B_DATA_INST/B2_DATA[16]
                         net (fo=1, unplaced)         0.000     1.966    mult02/out__0/DSP_A_B_DATA.B2_DATA<16>
                         DSP_PREADD_DATA (Prop_DSP_PREADD_DATA_B2_DATA[16]_B2B1[16])
                                                      0.092     2.058 r  mult02/out__0/DSP_PREADD_DATA_INST/B2B1[16]
                         net (fo=1, unplaced)         0.000     2.058    mult02/out__0/DSP_PREADD_DATA.B2B1<16>
                         DSP_MULTIPLIER (Prop_DSP_MULTIPLIER_B2B1[16]_U[43])
                                                      0.737     2.795 f  mult02/out__0/DSP_MULTIPLIER_INST/U[43]
                         net (fo=1, unplaced)         0.000     2.795    mult02/out__0/DSP_MULTIPLIER.U<43>
                         DSP_M_DATA (Prop_DSP_M_DATA_U[43]_U_DATA[43])
                                                      0.059     2.854 r  mult02/out__0/DSP_M_DATA_INST/U_DATA[43]
                         net (fo=1, unplaced)         0.000     2.854    mult02/out__0/DSP_M_DATA.U_DATA<43>
                         DSP_ALU (Prop_DSP_ALU_U_DATA[43]_ALU_OUT[47])
                                                      0.699     3.553 f  mult02/out__0/DSP_ALU_INST/ALU_OUT[47]
                         net (fo=1, unplaced)         0.000     3.553    mult02/out__0/DSP_ALU.ALU_OUT<47>
                         DSP_OUTPUT (Prop_DSP_OUTPUT_ALU_OUT[47]_PCOUT[47])
                                                      0.159     3.712 r  mult02/out__0/DSP_OUTPUT_INST/PCOUT[47]
                         net (fo=1, unplaced)         0.016     3.728    mult02/out__0__0/PCIN[47]
                         DSP_ALU (Prop_DSP_ALU_PCIN[47]_ALU_OUT[0])
                                                      0.698     4.426 f  mult02/out__0__0/DSP_ALU_INST/ALU_OUT[0]
                         net (fo=1, unplaced)         0.000     4.426    mult02/out__0__0/DSP_ALU.ALU_OUT<0>
                         DSP_OUTPUT (Prop_DSP_OUTPUT_ALU_OUT[0]_P[0])
                                                      0.141     4.567 r  mult02/out__0__0/DSP_OUTPUT_INST/P[0]
                         net (fo=1, unplaced)         0.241     4.808    mult02/out__0__0_n_105
                         LUT3 (Prop_LUT3_I1_O)        0.063     4.871 r  mult02/out[23]_i_15__2/O
                         net (fo=1, unplaced)         0.025     4.896    mult02/out[23]_i_15__2_n_0
                         CARRY8 (Prop_CARRY8_S[1]_CO[7])
                                                      0.245     5.141 r  mult02/out_reg[23]_i_1__2/CO[7]
                         net (fo=1, unplaced)         0.007     5.148    mult02/out_reg[23]_i_1__2_n_0
                         CARRY8 (Prop_CARRY8_CI_O[7])
                                                      0.146     5.294 r  mult02/out_reg[31]_i_2__2/O[7]
                         net (fo=1, unplaced)         0.031     5.325    mul_out2/out[15]
                         FDRE                                         r  mul_out2/out_reg[31]/D
  -------------------------------------------------------------------    -------------------




