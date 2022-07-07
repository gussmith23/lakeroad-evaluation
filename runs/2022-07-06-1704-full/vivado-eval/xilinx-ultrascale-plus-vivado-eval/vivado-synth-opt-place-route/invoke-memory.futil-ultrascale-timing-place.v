Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:19:14 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//invoke-memory.futil-ultrascale-timing-place.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack (MET) :             3.510ns  (required time - arrival time)
  Source:                 copy0/fsm/out_reg[1]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            copy0/comb_reg/out_reg[0]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        1.470ns  (logic 0.725ns (49.320%)  route 0.745ns (50.680%))
  Logic Levels:           4  (CARRY8=1 LUT3=1 LUT5=1 LUT6=1)
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
    SLICE_X21Y92         FDRE                                         r  copy0/fsm/out_reg[1]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X21Y92         FDRE (Prop_GFF_SLICEL_C_Q)
                                                      0.097     0.133 r  copy0/fsm/out_reg[1]/Q
                         net (fo=50, estimated)       0.256     0.389    copy0/fsm/fsm_out[1]
    SLICE_X21Y92         LUT5 (Prop_H5LUT_SLICEL_I0_O)
                                                      0.195     0.584 r  copy0/fsm/A_LUT_0_i_2__0/O
                         net (fo=6, estimated)        0.237     0.821    copy0/lt/_impl/C_LUT_2/I1
    SLICE_X21Y90         LUT6 (Prop_C6LUT_SLICEL_I1_O)
                                                      0.148     0.969 r  copy0/lt/_impl/C_LUT_2/LUT6/O
                         net (fo=1, routed)           0.011     0.980    copy0/lt/_impl/luts_O6_1[2]
    SLICE_X21Y90         CARRY8 (Prop_CARRY8_SLICEL_S[2]_CO[7])
                                                      0.196     1.176 r  copy0/lt/_impl/carry_8/CO[7]
                         net (fo=1, estimated)        0.215     1.391    copy0/lt/_impl/lt_out
    SLICE_X21Y92         LUT3 (Prop_B5LUT_SLICEL_I0_O)
                                                      0.089     1.480 r  copy0/lt/_impl/out[0]_i_1__0/O
                         net (fo=1, routed)           0.026     1.506    copy0/comb_reg/out_reg[0]_0
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
                         arrival time                          -1.506    
  -------------------------------------------------------------------
                         slack                                  3.510    




