Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:16:46 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//while.futil-ultrascale-timing-route.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack (MET) :             3.292ns  (required time - arrival time)
  Source:                 comb_reg/done_reg/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            comb_reg/out_reg[0]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        1.688ns  (logic 0.885ns (52.429%)  route 0.803ns (47.571%))
  Logic Levels:           7  (CARRY8=4 LUT3=1 LUT6=2)
  Clock Path Skew:        -0.012ns (DCD - SCD + CPR)
    Destination Clock Delay (DCD):    0.024ns = ( 5.024 - 5.000 ) 
    Source Clock Delay      (SCD):    0.036ns
    Clock Pessimism Removal (CPR):    0.000ns
  Clock Uncertainty:      0.035ns  ((TSJ^2 + TIJ^2)^1/2 + DJ) / 2 + PE
    Total System Jitter     (TSJ):    0.071ns
    Total Input Jitter      (TIJ):    0.000ns
    Discrete Jitter          (DJ):    0.000ns
    Phase Error              (PE):    0.000ns

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=4, unset)            0.036     0.036    comb_reg/clk
    SLICE_X25Y110        FDRE                                         r  comb_reg/done_reg/C
  -------------------------------------------------------------------    -------------------
    SLICE_X25Y110        FDRE (Prop_EFF_SLICEL_C_Q)
                                                      0.096     0.132 r  comb_reg/done_reg/Q
                         net (fo=36, routed)          0.290     0.422    fsm/comb_reg_done
    SLICE_X25Y110        LUT6 (Prop_H6LUT_SLICEL_I0_O)
                                                      0.179     0.601 f  fsm/A_LUT_0_i_1__0/O
                         net (fo=2, routed)           0.177     0.778    lt/_impl/A_LUT_0/I0
    SLICE_X26Y110        LUT6 (Prop_A6LUT_SLICEL_I0_O)
                                                      0.178     0.956 r  lt/_impl/A_LUT_0/LUT6/O
                         net (fo=1, routed)           0.011     0.967    lt/_impl/luts_O6_1[0]
    SLICE_X26Y110        CARRY8 (Prop_CARRY8_SLICEL_S[0]_CO[7])
                                                      0.238     1.205 r  lt/_impl/carry_8/CO[7]
                         net (fo=1, routed)           0.028     1.233    lt/_impl/co_3[7]
    SLICE_X26Y111        CARRY8 (Prop_CARRY8_SLICEL_CI_CO[7])
                                                      0.023     1.256 r  lt/_impl/carry_17/CO[7]
                         net (fo=1, routed)           0.028     1.284    lt/_impl/co_7[7]
    SLICE_X26Y112        CARRY8 (Prop_CARRY8_SLICEL_CI_CO[7])
                                                      0.023     1.307 r  lt/_impl/carry_26/CO[7]
                         net (fo=1, routed)           0.028     1.335    lt/_impl/co_11[7]
    SLICE_X26Y113        CARRY8 (Prop_CARRY8_SLICEL_CI_CO[7])
                                                      0.030     1.365 r  lt/_impl/carry_35/CO[7]
                         net (fo=1, routed)           0.219     1.584    lt/_impl/lt_out
    SLICE_X25Y111        LUT3 (Prop_D5LUT_SLICEL_I0_O)
                                                      0.118     1.702 r  lt/_impl/out[0]_i_1__0/O
                         net (fo=1, routed)           0.022     1.724    comb_reg/out_reg[0]_0
    SLICE_X25Y111        FDRE                                         r  comb_reg/out_reg[0]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=4, unset)            0.024     5.024    comb_reg/clk
    SLICE_X25Y111        FDRE                                         r  comb_reg/out_reg[0]/C
                         clock pessimism              0.000     5.024    
                         clock uncertainty           -0.035     4.989    
    SLICE_X25Y111        FDRE (Setup_DFF2_SLICEL_C_D)
                                                      0.027     5.016    comb_reg/out_reg[0]
  -------------------------------------------------------------------
                         required time                          5.016    
                         arrival time                          -1.724    
  -------------------------------------------------------------------
                         slack                                  3.292    




