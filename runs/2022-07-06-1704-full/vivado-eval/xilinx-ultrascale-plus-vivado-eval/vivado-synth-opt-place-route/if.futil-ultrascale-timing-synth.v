Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:31:55 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//if.futil-ultrascale-timing-synth.v
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
  Data Path Delay:        1.371ns  (logic 0.601ns (43.837%)  route 0.770ns (56.163%))
  Logic Levels:           8  (CARRY8=4 FDRE=1 LUT4=1 LUT5=1 LUT6=1)

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         FDRE                         0.000     0.000 r  fsm/out_reg[0]/C
                         FDRE (Prop_FDRE_C_Q)         0.093     0.093 f  fsm/out_reg[0]/Q
                         net (fo=9, unplaced)         0.139     0.232    fsm/Q[0]
                         LUT4 (Prop_LUT4_I0_O)        0.116     0.348 r  fsm/A_LUT_0_i_1/O
                         net (fo=9, unplaced)         0.241     0.589    lt/_impl/A_LUT_0/I1
                         LUT5 (Prop_LUT5_I1_O)        0.085     0.674 r  lt/_impl/A_LUT_0/LUT5/O
                         net (fo=1, unplaced)         0.287     0.961    lt/_impl/luts_O5_0[0]
                         CARRY8 (Prop_CARRY8_DI[0]_CO[7])
                                                      0.177     1.138 r  lt/_impl/carry_8/CO[7]
                         net (fo=1, unplaced)         0.007     1.145    lt/_impl/co_3[7]
                         CARRY8 (Prop_CARRY8_CI_CO[7])
                                                      0.030     1.175 r  lt/_impl/carry_17/CO[7]
                         net (fo=1, unplaced)         0.007     1.182    lt/_impl/co_7[7]
                         CARRY8 (Prop_CARRY8_CI_CO[7])
                                                      0.030     1.212 r  lt/_impl/carry_26/CO[7]
                         net (fo=1, unplaced)         0.007     1.219    lt/_impl/co_11[7]
                         CARRY8 (Prop_CARRY8_CI_CO[7])
                                                      0.030     1.249 r  lt/_impl/carry_35/CO[7]
                         net (fo=1, unplaced)         0.024     1.273    fsm/out0
                         LUT6 (Prop_LUT6_I0_O)        0.040     1.313 r  fsm/out[0]_i_1/O
                         net (fo=1, unplaced)         0.058     1.371    comb_reg/out_reg[0]_0
                         FDRE                                         r  comb_reg/out_reg[0]/D
  -------------------------------------------------------------------    -------------------




