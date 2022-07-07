Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 02:55:52 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//std-sdiv.futil-ultrascale-timing-route.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack (MET) :             1.922ns  (required time - arrival time)
  Source:                 div/comp/running_reg/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            div/comp/divisor_reg[33]/R
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        2.961ns  (logic 0.400ns (13.509%)  route 2.561ns (86.491%))
  Logic Levels:           3  (LUT4=1 LUT6=2)
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
                         net (fo=332, unset)          0.035     0.035    div/comp/clk
    SLICE_X32Y77         FDRE                                         r  div/comp/running_reg/C
  -------------------------------------------------------------------    -------------------
    SLICE_X32Y77         FDRE (Prop_DFF_SLICEL_C_Q)
                                                      0.096     0.131 r  div/comp/running_reg/Q
                         net (fo=37, routed)          1.016     1.147    div/comp/E[0]
    SLICE_X38Y77         LUT4 (Prop_H6LUT_SLICEL_I2_O)
                                                      0.116     1.263 f  div/comp/divisor[62]_i_9/O
                         net (fo=1, routed)           0.055     1.318    div/comp/divisor[62]_i_9_n_0
    SLICE_X38Y77         LUT6 (Prop_C6LUT_SLICEL_I0_O)
                                                      0.148     1.466 f  div/comp/divisor[62]_i_4/O
                         net (fo=1, routed)           0.053     1.519    div/comp/divisor[62]_i_4_n_0
    SLICE_X38Y76         LUT6 (Prop_H6LUT_SLICEL_I4_O)
                                                      0.040     1.559 r  div/comp/divisor[62]_i_1/O
                         net (fo=129, routed)         1.437     2.996    div/comp/SR[0]
    SLICE_X30Y88         FDRE                                         r  div/comp/divisor_reg[33]/R
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=332, unset)          0.025     5.025    div/comp/clk
    SLICE_X30Y88         FDRE                                         r  div/comp/divisor_reg[33]/C
                         clock pessimism              0.000     5.025    
                         clock uncertainty           -0.035     4.990    
    SLICE_X30Y88         FDRE (Setup_HFF_SLICEL_C_R)
                                                     -0.072     4.918    div/comp/divisor_reg[33]
  -------------------------------------------------------------------
                         required time                          4.918    
                         arrival time                          -2.996    
  -------------------------------------------------------------------
                         slack                                  1.922    




