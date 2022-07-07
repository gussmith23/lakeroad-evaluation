Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:19:18 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//invoke-memory.futil-ultrascale-timing-route.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack (MET) :             3.296ns  (required time - arrival time)
  Source:                 copy0/fsm/out_reg[2]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            copy0/comb_reg/out_reg[0]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        1.684ns  (logic 0.840ns (49.881%)  route 0.844ns (50.119%))
  Logic Levels:           4  (CARRY8=1 LUT3=1 LUT6=2)
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
                         net (fo=8, unset)            0.036     0.036    copy0/fsm/clk
    SLICE_X21Y92         FDRE                                         r  copy0/fsm/out_reg[2]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X21Y92         FDRE (Prop_FFF_SLICEL_C_Q)
                                                      0.096     0.132 f  copy0/fsm/out_reg[2]/Q
                         net (fo=50, routed)          0.340     0.472    copy0/fsm/fsm_out[2]
    SLICE_X21Y91         LUT6 (Prop_H6LUT_SLICEL_I2_O)
                                                      0.179     0.651 r  copy0/fsm/A_LUT_0_i_1__0/O
                         net (fo=2, routed)           0.297     0.948    copy0/lt/_impl/A_LUT_0/I0
    SLICE_X21Y90         LUT6 (Prop_A6LUT_SLICEL_I0_O)
                                                      0.178     1.126 r  copy0/lt/_impl/A_LUT_0/LUT6/O
                         net (fo=1, routed)           0.011     1.137    copy0/lt/_impl/luts_O6_1[0]
    SLICE_X21Y90         CARRY8 (Prop_CARRY8_SLICEL_S[0]_CO[7])
                                                      0.245     1.382 r  copy0/lt/_impl/carry_8/CO[7]
                         net (fo=1, routed)           0.170     1.552    copy0/lt/_impl/lt_out
    SLICE_X21Y92         LUT3 (Prop_B5LUT_SLICEL_I0_O)
                                                      0.142     1.694 r  copy0/lt/_impl/out[0]_i_1__0/O
                         net (fo=1, routed)           0.026     1.720    copy0/comb_reg/out_reg[0]_0
    SLICE_X21Y92         FDRE                                         r  copy0/comb_reg/out_reg[0]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=8, unset)            0.024     5.024    copy0/comb_reg/clk
    SLICE_X21Y92         FDRE                                         r  copy0/comb_reg/out_reg[0]/C
                         clock pessimism              0.000     5.024    
                         clock uncertainty           -0.035     4.989    
    SLICE_X21Y92         FDRE (Setup_BFF2_SLICEL_C_D)
                                                      0.027     5.016    copy0/comb_reg/out_reg[0]
  -------------------------------------------------------------------
                         required time                          5.016    
                         arrival time                          -1.720    
  -------------------------------------------------------------------
                         slack                                  3.296    




