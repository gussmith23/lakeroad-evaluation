Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:08:07 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//lpm.futil-vanilla-timing-route.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack (MET) :             1.432ns  (required time - arrival time)
  Source:                 tcam/pd63/out_reg[0]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            tcam/ce07/addr/out_reg[3]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        3.550ns  (logic 0.649ns (18.282%)  route 2.901ns (81.718%))
  Logic Levels:           5  (LUT4=3 LUT5=1 LUT6=1)
  Clock Path Skew:        -0.010ns (DCD - SCD + CPR)
    Destination Clock Delay (DCD):    0.025ns = ( 5.025 - 5.000 ) 
    Source Clock Delay      (SCD):    0.035ns
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
                         net (fo=653, unset)          0.035     0.035    tcam/pd63/clk
    SLICE_X30Y33         FDRE                                         r  tcam/pd63/out_reg[0]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X30Y33         FDRE (Prop_AFF_SLICEL_C_Q)
                                                      0.096     0.131 f  tcam/pd63/out_reg[0]/Q
                         net (fo=11, routed)          0.489     0.620    tcam/pd78/pd63_out
    SLICE_X30Y17         LUT4 (Prop_H6LUT_SLICEL_I1_O)
                                                      0.179     0.799 f  tcam/pd78/out[0]_i_4__10/O
                         net (fo=1, routed)           0.244     1.043    tcam/pd73/out_reg[0]_0
    SLICE_X28Y17         LUT4 (Prop_H6LUT_SLICEM_I1_O)
                                                      0.117     1.160 f  tcam/pd73/out[0]_i_2__86/O
                         net (fo=30, routed)          0.789     1.949    tcam/fsm32/par1_done_in
    SLICE_X33Y30         LUT5 (Prop_G6LUT_SLICEL_I1_O)
                                                      0.063     2.012 r  tcam/fsm32/done_i_2__22/O
                         net (fo=113, routed)         0.843     2.855    tcam/ce07/fsm/par1_go_in
    SLICE_X26Y21         LUT6 (Prop_F6LUT_SLICEL_I2_O)
                                                      0.114     2.969 r  tcam/ce07/fsm/done_i_2__4/O
                         net (fo=6, routed)           0.159     3.128    tcam/ce07/fsm/done_i_2__4_n_0
    SLICE_X26Y22         LUT4 (Prop_D5LUT_SLICEL_I3_O)
                                                      0.080     3.208 r  tcam/ce07/fsm/done_i_1__19/O
                         net (fo=4, routed)           0.377     3.585    tcam/ce07/addr/D[1]
    SLICE_X26Y21         FDRE                                         r  tcam/ce07/addr/out_reg[3]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=653, unset)          0.025     5.025    tcam/ce07/addr/clk
    SLICE_X26Y21         FDRE                                         r  tcam/ce07/addr/out_reg[3]/C
                         clock pessimism              0.000     5.025    
                         clock uncertainty           -0.035     4.990    
    SLICE_X26Y21         FDRE (Setup_GFF_SLICEL_C_D)
                                                      0.027     5.017    tcam/ce07/addr/out_reg[3]
  -------------------------------------------------------------------
                         required time                          5.017    
                         arrival time                          -3.585    
  -------------------------------------------------------------------
                         slack                                  1.432    




