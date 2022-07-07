Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:12:02 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//no-matches.futil-vanilla-timing-place.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack (MET) :             2.884ns  (required time - arrival time)
  Source:                 tcam/pd81/out_reg[0]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            tcam/ce10/len/out_reg[4]/CE
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        2.026ns  (logic 0.476ns (23.495%)  route 1.550ns (76.505%))
  Logic Levels:           4  (LUT3=1 LUT4=1 LUT6=2)
  Clock Path Skew:        -0.013ns (DCD - SCD + CPR)
    Destination Clock Delay (DCD):    0.024ns = ( 5.024 - 5.000 ) 
    Source Clock Delay      (SCD):    0.037ns
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
                         net (fo=627, unset)          0.037     0.037    tcam/pd81/clk
    SLICE_X28Y49         FDRE                                         r  tcam/pd81/out_reg[0]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X28Y49         FDRE (Prop_BFF_SLICEM_C_Q)
                                                      0.095     0.132 f  tcam/pd81/out_reg[0]/Q
                         net (fo=9, estimated)        0.357     0.489    tcam/pd81/pd81_out
    SLICE_X21Y49         LUT4 (Prop_C6LUT_SLICEL_I0_O)
                                                      0.148     0.637 f  tcam/pd81/done_i_4__0/O
                         net (fo=1, estimated)        0.163     0.800    tcam/fsm32/out_reg[0]_18
    SLICE_X21Y50         LUT6 (Prop_F6LUT_SLICEL_I1_O)
                                                      0.114     0.914 f  tcam/fsm32/done_i_2__40/O
                         net (fo=57, estimated)       0.444     1.358    tcam/fsm32/out_reg[0]_3
    SLICE_X23Y40         LUT3 (Prop_D5LUT_SLICEL_I0_O)
                                                      0.080     1.438 r  tcam/fsm32/out[4]_i_3__11/O
                         net (fo=6, estimated)        0.263     1.701    tcam/ce10/fsm/invoke47_go_in
    SLICE_X22Y41         LUT6 (Prop_F6LUT_SLICEL_I2_O)
                                                      0.039     1.740 r  tcam/ce10/fsm/out[4]_i_1__11/O
                         net (fo=4, estimated)        0.323     2.063    tcam/ce10/len/E[0]
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
                         arrival time                          -2.063    
  -------------------------------------------------------------------
                         slack                                  2.884    




