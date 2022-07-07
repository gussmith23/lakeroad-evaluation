Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:15:11 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//while.futil-vanilla-timing-synth.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack:                    inf
  Source:                 fsm/out_reg[0]/C
                            (rising edge-triggered cell FDRE)
  Destination:            comb_reg/out_reg[0]/D
  Path Group:             (none)
  Path Type:              Max at Slow Process Corner
  Data Path Delay:        1.426ns  (logic 0.733ns (51.403%)  route 0.693ns (48.597%))
  Logic Levels:           6  (CARRY8=2 FDRE=1 LUT3=2 LUT5=1)

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         FDRE                         0.000     0.000 r  fsm/out_reg[0]/C
                         FDRE (Prop_FDRE_C_Q)         0.093     0.093 r  fsm/out_reg[0]/Q
                         net (fo=73, unplaced)        0.192     0.285    fsm/fsm_out[0]
                         LUT5 (Prop_LUT5_I0_O)        0.200     0.485 r  fsm/out_carry_i_10/O
                         net (fo=16, unplaced)        0.254     0.739    fsm/out_reg[0]_0
                         LUT3 (Prop_LUT3_I2_O)        0.039     0.778 r  fsm/out_carry_i_8/O
                         net (fo=1, unplaced)         0.025     0.803    lt/out_carry__0_0[1]
                         CARRY8 (Prop_CARRY8_S[1]_CO[7])
                                                      0.245     1.048 r  lt/out_carry/CO[7]
                         net (fo=1, unplaced)         0.007     1.055    lt/out_carry_n_0
                         CARRY8 (Prop_CARRY8_CI_CO[6])
                                                      0.116     1.171 r  lt/out_carry__0/CO[6]
                         net (fo=1, unplaced)         0.157     1.328    comb_reg/CO[0]
                         LUT3 (Prop_LUT3_I2_O)        0.040     1.368 r  comb_reg/out[0]_i_1__0/O
                         net (fo=1, unplaced)         0.058     1.426    comb_reg/out[0]_i_1__0_n_0
                         FDRE                                         r  comb_reg/out_reg[0]/D
  -------------------------------------------------------------------    -------------------




