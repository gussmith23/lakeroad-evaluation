Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:16:35 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//while.futil-ultrascale-timing-opt.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack (MET) :             3.489ns  (required time - arrival time)
  Source:                 comb_reg/done_reg/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            comb_reg/out_reg[0]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        1.503ns  (logic 0.664ns (44.178%)  route 0.839ns (55.822%))
  Logic Levels:           7  (CARRY8=4 LUT3=1 LUT5=1 LUT6=1)
  Clock Uncertainty:      0.035ns  ((TSJ^2 + TIJ^2)^1/2 + DJ) / 2 + PE
    Total System Jitter     (TSJ):    0.071ns
    Total Input Jitter      (TIJ):    0.000ns
    Discrete Jitter          (DJ):    0.000ns
    Phase Error              (PE):    0.000ns

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=4, unset)            0.000     0.000    comb_reg/clk
                         FDRE                                         r  comb_reg/done_reg/C
  -------------------------------------------------------------------    -------------------
                         FDRE (Prop_FDRE_C_Q)         0.093     0.093 r  comb_reg/done_reg/Q
                         net (fo=36, unplaced)        0.239     0.332    fsm/comb_reg_done
                         LUT6 (Prop_LUT6_I0_O)        0.179     0.511 f  fsm/A_LUT_0_i_1__0/O
                         net (fo=2, unplaced)         0.210     0.721    lt/_impl/A_LUT_0/I0
                         LUT5 (Prop_LUT5_I0_O)        0.085     0.806 r  lt/_impl/A_LUT_0/LUT5/O
                         net (fo=1, unplaced)         0.287     1.093    lt/_impl/luts_O5_0[0]
                         CARRY8 (Prop_CARRY8_DI[0]_CO[7])
                                                      0.177     1.270 r  lt/_impl/carry_8/CO[7]
                         net (fo=1, unplaced)         0.007     1.277    lt/_impl/co_3[7]
                         CARRY8 (Prop_CARRY8_CI_CO[7])
                                                      0.030     1.307 r  lt/_impl/carry_17/CO[7]
                         net (fo=1, unplaced)         0.007     1.314    lt/_impl/co_7[7]
                         CARRY8 (Prop_CARRY8_CI_CO[7])
                                                      0.030     1.344 r  lt/_impl/carry_26/CO[7]
                         net (fo=1, unplaced)         0.007     1.351    lt/_impl/co_11[7]
                         CARRY8 (Prop_CARRY8_CI_CO[7])
                                                      0.030     1.381 r  lt/_impl/carry_35/CO[7]
                         net (fo=1, unplaced)         0.024     1.405    lt/_impl/lt_out
                         LUT3 (Prop_LUT3_I0_O)        0.040     1.445 r  lt/_impl/out[0]_i_1__0/O
                         net (fo=1, unplaced)         0.058     1.503    comb_reg/out_reg[0]_0
                         FDRE                                         r  comb_reg/out_reg[0]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=4, unset)            0.000     5.000    comb_reg/clk
                         FDRE                                         r  comb_reg/out_reg[0]/C
                         clock pessimism              0.000     5.000    
                         clock uncertainty           -0.035     4.965    
                         FDRE (Setup_FDRE_C_D)        0.027     4.992    comb_reg/out_reg[0]
  -------------------------------------------------------------------
                         required time                          4.992    
                         arrival time                          -1.503    
  -------------------------------------------------------------------
                         slack                                  3.489    




