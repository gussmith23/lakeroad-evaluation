Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 02:36:12 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//std-fp-sdiv.futil-vanilla-timing-synth.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack:                    inf
  Source:                 div/comp/done_reg/C
                            (rising edge-triggered cell FDRE)
  Destination:            div/comp/acc_reg[12]/D
  Path Group:             (none)
  Path Type:              Max at Slow Process Corner
  Data Path Delay:        2.405ns  (logic 1.073ns (44.615%)  route 1.332ns (55.385%))
  Logic Levels:           10  (CARRY8=5 FDRE=1 LUT3=1 LUT4=2 LUT6=1)

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         FDRE                         0.000     0.000 r  div/comp/done_reg/C
                         FDRE (Prop_FDRE_C_Q)         0.093     0.093 r  div/comp/done_reg/Q
                         net (fo=70, unplaced)        0.254     0.347    fsm/div_done
                         LUT6 (Prop_LUT6_I0_O)        0.178     0.525 r  fsm/right_save[8]_i_10/O
                         net (fo=1, unplaced)         0.025     0.550    fsm/right_save[8]_i_10_n_0
                         CARRY8 (Prop_CARRY8_S[1]_CO[7])
                                                      0.245     0.795 r  fsm/right_save_reg[8]_i_2/CO[7]
                         net (fo=1, unplaced)         0.007     0.802    fsm/right_save_reg[8]_i_2_n_0
                         CARRY8 (Prop_CARRY8_CI_CO[7])
                                                      0.030     0.832 r  fsm/right_save_reg[16]_i_2/CO[7]
                         net (fo=1, unplaced)         0.007     0.839    fsm/right_save_reg[16]_i_2_n_0
                         CARRY8 (Prop_CARRY8_CI_O[0])
                                                      0.072     0.911 f  fsm/right_save_reg[24]_i_2/O[0]
                         net (fo=5, unplaced)         0.228     1.139    comb_reg1/right_abs0[16]
                         LUT4 (Prop_LUT4_I0_O)        0.085     1.224 f  comb_reg1/right_save[17]_i_1/O
                         net (fo=3, unplaced)         0.216     1.440    div/comp/D[17]
                         LUT4 (Prop_LUT4_I1_O)        0.040     1.480 r  div/comp/quotient_next1_carry__0_i_8/O
                         net (fo=1, unplaced)         0.259     1.739    div/comp/quotient_next1_carry__0_i_8_n_0
                         CARRY8 (Prop_CARRY8_DI[0]_CO[7])
                                                      0.177     1.916 r  div/comp/quotient_next1_carry__0/CO[7]
                         net (fo=1, unplaced)         0.007     1.923    div/comp/quotient_next1_carry__0_n_0
                         CARRY8 (Prop_CARRY8_CI_CO[0])
                                                      0.068     1.991 r  div/comp/quotient_next1_carry__1/CO[0]
                         net (fo=34, unplaced)        0.271     2.262    div/comp/quotient_next1
                         LUT3 (Prop_LUT3_I1_O)        0.085     2.347 r  div/comp/acc[12]_i_1/O
                         net (fo=1, unplaced)         0.058     2.405    div/comp/acc[12]_i_1_n_0
                         FDRE                                         r  div/comp/acc_reg[12]/D
  -------------------------------------------------------------------    -------------------




