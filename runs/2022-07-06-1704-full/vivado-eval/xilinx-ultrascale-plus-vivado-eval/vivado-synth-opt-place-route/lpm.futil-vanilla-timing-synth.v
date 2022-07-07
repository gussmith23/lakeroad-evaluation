Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:07:45 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//lpm.futil-vanilla-timing-synth.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack:                    inf
  Source:                 tcam/fsm32/out_reg[0]/C
                            (rising edge-triggered cell FDRE)
  Destination:            tcam/me0/r/out_reg[0]/D
  Path Group:             (none)
  Path Type:              Max at Slow Process Corner
  Data Path Delay:        2.160ns  (logic 1.105ns (51.157%)  route 1.055ns (48.843%))
  Logic Levels:           8  (CARRY8=1 FDRE=1 LUT4=3 LUT5=2 LUT6=1)

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         FDRE                         0.000     0.000 r  tcam/fsm32/out_reg[0]/C
                         FDRE (Prop_FDRE_C_Q)         0.093     0.093 r  tcam/fsm32/out_reg[0]/Q
                         net (fo=43, unplaced)        0.174     0.267    tcam/fsm32/out_reg_n_0_[0]
                         LUT4 (Prop_LUT4_I0_O)        0.171     0.438 r  tcam/fsm32/out[3]_i_3__2/O
                         net (fo=8, unplaced)         0.184     0.622    tcam/fsm32/tdcc32_done_in
                         LUT4 (Prop_LUT4_I0_O)        0.122     0.744 f  tcam/fsm32/done_i_4__0/O
                         net (fo=26, unplaced)        0.265     1.009    tcam/fsm32/done_i_4__0_n_0
                         LUT4 (Prop_LUT4_I0_O)        0.085     1.094 f  tcam/fsm32/out_carry_i_2__2/O
                         net (fo=23, unplaced)        0.208     1.302    tcam/l0/out_carry_i_3
                         LUT5 (Prop_LUT5_I1_O)        0.122     1.424 r  tcam/l0/out_carry_i_15/O
                         net (fo=1, unplaced)         0.121     1.545    tcam/fsm32/out_carry_2
                         LUT6 (Prop_LUT6_I0_O)        0.179     1.724 r  tcam/fsm32/out_carry_i_8/O
                         net (fo=1, unplaced)         0.021     1.745    tcam/me0/eq/S[0]
                         CARRY8 (Prop_CARRY8_S[0]_CO[7])
                                                      0.248     1.993 r  tcam/me0/eq/out_carry/CO[7]
                         net (fo=1, unplaced)         0.024     2.017    tcam/me0/r/CO[0]
                         LUT5 (Prop_LUT5_I0_O)        0.085     2.102 r  tcam/me0/r/out[0]_i_1/O
                         net (fo=1, unplaced)         0.058     2.160    tcam/me0/r/out[0]_i_1_n_0
                         FDRE                                         r  tcam/me0/r/out_reg[0]/D
  -------------------------------------------------------------------    -------------------




