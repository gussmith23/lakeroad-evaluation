Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:12:08 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//no-matches.futil-vanilla-timing-route.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack (MET) :             2.335ns  (required time - arrival time)
  Source:                 fsm/out_reg[1]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            tcam/ce10/len/out_reg[4]/CE
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        2.577ns  (logic 0.723ns (28.056%)  route 1.854ns (71.944%))
  Logic Levels:           4  (LUT3=1 LUT4=1 LUT6=2)
  Clock Path Skew:        -0.011ns (DCD - SCD + CPR)
    Destination Clock Delay (DCD):    0.024ns = ( 5.024 - 5.000 ) 
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
                         net (fo=627, unset)          0.035     0.035    fsm/clk
    SLICE_X22Y55         FDRE                                         r  fsm/out_reg[1]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X22Y55         FDRE (Prop_DFF2_SLICEL_C_Q)
                                                      0.098     0.133 f  fsm/out_reg[1]/Q
                         net (fo=22, routed)          0.366     0.499    tcam/pd94/Q[0]
    SLICE_X22Y53         LUT4 (Prop_A5LUT_SLICEL_I3_O)
                                                      0.199     0.698 f  tcam/pd94/done_i_2__45/O
                         net (fo=8, routed)           0.259     0.957    tcam/fsm32/done_reg
    SLICE_X21Y50         LUT6 (Prop_F6LUT_SLICEL_I4_O)
                                                      0.114     1.071 f  tcam/fsm32/done_i_2__40/O
                         net (fo=57, routed)          0.682     1.753    tcam/fsm32/out_reg[0]_3
    SLICE_X23Y40         LUT3 (Prop_D5LUT_SLICEL_I0_O)
                                                      0.164     1.917 r  tcam/fsm32/out[4]_i_3__11/O
                         net (fo=6, routed)           0.203     2.120    tcam/ce10/fsm/invoke47_go_in
    SLICE_X22Y41         LUT6 (Prop_F6LUT_SLICEL_I2_O)
                                                      0.148     2.268 r  tcam/ce10/fsm/out[4]_i_1__11/O
                         net (fo=4, routed)           0.344     2.612    tcam/ce10/len/E[0]
    SLICE_X23Y43         FDRE                                         r  tcam/ce10/len/out_reg[4]/CE
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=627, unset)          0.024     5.024    tcam/ce10/len/clk
    SLICE_X23Y43         FDRE                                         r  tcam/ce10/len/out_reg[4]/C
                         clock pessimism              0.000     5.024    
                         clock uncertainty           -0.035     4.989    
    SLICE_X23Y43         FDRE (Setup_DFF2_SLICEL_C_CE)
                                                     -0.042     4.947    tcam/ce10/len/out_reg[4]
  -------------------------------------------------------------------
                         required time                          4.947    
                         arrival time                          -2.612    
  -------------------------------------------------------------------
                         slack                                  2.335    




