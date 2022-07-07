Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:19:00 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//invoke-memory.futil-ultrascale-timing-synth.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack:                    inf
  Source:                 copy0/comb_reg/done_reg/C
                            (rising edge-triggered cell FDRE)
  Destination:            copy0/comb_reg/out_reg[0]/D
  Path Group:             (none)
  Path Type:              Max at Slow Process Corner
  Data Path Delay:        1.338ns  (logic 0.611ns (45.665%)  route 0.727ns (54.335%))
  Logic Levels:           5  (CARRY8=1 FDRE=1 LUT3=1 LUT5=1 LUT6=1)

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         FDRE                         0.000     0.000 r  copy0/comb_reg/done_reg/C
                         FDRE (Prop_FDRE_C_Q)         0.093     0.093 r  copy0/comb_reg/done_reg/Q
                         net (fo=7, unplaced)         0.202     0.295    copy0/fsm/comb_reg_done
                         LUT6 (Prop_LUT6_I0_O)        0.179     0.474 f  copy0/fsm/A_LUT_0_i_1__0/O
                         net (fo=2, unplaced)         0.156     0.630    copy0/lt/_impl/A_LUT_0/I0
                         LUT5 (Prop_LUT5_I0_O)        0.122     0.752 r  copy0/lt/_impl/A_LUT_0/LUT5/O
                         net (fo=1, unplaced)         0.287     1.039    copy0/lt/_impl/luts_O5_0[0]
                         CARRY8 (Prop_CARRY8_DI[0]_CO[7])
                                                      0.177     1.216 r  copy0/lt/_impl/carry_8/CO[7]
                         net (fo=1, unplaced)         0.024     1.240    copy0/lt/_impl/lt_out
                         LUT3 (Prop_LUT3_I0_O)        0.040     1.280 r  copy0/lt/_impl/out[0]_i_1__0/O
                         net (fo=1, unplaced)         0.058     1.338    copy0/comb_reg/out_reg[0]_0
                         FDRE                                         r  copy0/comb_reg/out_reg[0]/D
  -------------------------------------------------------------------    -------------------




