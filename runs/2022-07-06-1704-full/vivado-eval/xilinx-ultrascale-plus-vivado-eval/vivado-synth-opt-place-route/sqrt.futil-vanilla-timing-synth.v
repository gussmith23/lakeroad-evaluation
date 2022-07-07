Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 02:59:35 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//sqrt.futil-vanilla-timing-synth.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack:                    inf
  Source:                 s/comp/quotient_reg[0]/C
                            (rising edge-triggered cell FDRE)
  Destination:            s/comp/acc_reg[3]/D
  Path Group:             (none)
  Path Type:              Max at Slow Process Corner
  Data Path Delay:        1.169ns  (logic 0.624ns (53.379%)  route 0.545ns (46.621%))
  Logic Levels:           8  (CARRY8=5 FDRE=1 LUT2=1 LUT4=1)

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         FDRE                         0.000     0.000 r  s/comp/quotient_reg[0]/C
                         FDRE (Prop_FDRE_C_Q)         0.093     0.093 r  s/comp/quotient_reg[0]/Q
                         net (fo=3, unplaced)         0.164     0.257    s/comp/quotient[0]
                         LUT2 (Prop_LUT2_I1_O)        0.039     0.296 r  s/comp/quotient_next1_carry_i_7__2/O
                         net (fo=1, unplaced)         0.025     0.321    s/comp/quotient_next1_carry_i_7__2_n_0
                         CARRY8 (Prop_CARRY8_S[1]_CO[7])
                                                      0.245     0.566 r  s/comp/quotient_next1_carry/CO[7]
                         net (fo=1, unplaced)         0.007     0.573    s/comp/quotient_next1_carry_n_0
                         CARRY8 (Prop_CARRY8_CI_CO[7])
                                                      0.030     0.603 r  s/comp/quotient_next1_carry__0/CO[7]
                         net (fo=1, unplaced)         0.007     0.610    s/comp/quotient_next1_carry__0_n_0
                         CARRY8 (Prop_CARRY8_CI_CO[7])
                                                      0.030     0.640 r  s/comp/quotient_next1_carry__1/CO[7]
                         net (fo=1, unplaced)         0.007     0.647    s/comp/quotient_next1_carry__1_n_0
                         CARRY8 (Prop_CARRY8_CI_CO[7])
                                                      0.030     0.677 r  s/comp/quotient_next1_carry__2/CO[7]
                         net (fo=1, unplaced)         0.007     0.684    s/comp/quotient_next1_carry__2_n_0
                         CARRY8 (Prop_CARRY8_CI_O[0])
                                                      0.072     0.756 r  s/comp/quotient_next1_carry__3/O[0]
                         net (fo=33, unplaced)        0.270     1.026    s/comp/p_0_in
                         LUT4 (Prop_LUT4_I3_O)        0.085     1.111 r  s/comp/acc[3]_i_1/O
                         net (fo=1, unplaced)         0.058     1.169    s/comp/acc[3]_i_1_n_0
                         FDRE                                         r  s/comp/acc_reg[3]/D
  -------------------------------------------------------------------    -------------------




