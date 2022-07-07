Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:17:58 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//invoke-memory.futil-vanilla-timing-place.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack (MET) :             3.997ns  (required time - arrival time)
  Source:                 copy0/fsm/out_reg[0]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            copy0/fsm/out_reg[0]/CE
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        0.915ns  (logic 0.325ns (35.519%)  route 0.590ns (64.481%))
  Logic Levels:           2  (LUT6=1 MUXF7=1)
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
                         net (fo=8, unset)            0.035     0.035    copy0/fsm/clk
    SLICE_X21Y99         FDRE                                         r  copy0/fsm/out_reg[0]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X21Y99         FDRE (Prop_AFF_SLICEL_C_Q)
                                                      0.096     0.131 r  copy0/fsm/out_reg[0]/Q
                         net (fo=44, estimated)       0.237     0.368    copy0/fsm/fsm_out[0]
    SLICE_X21Y99         LUT6 (Prop_G6LUT_SLICEL_I1_O)
                                                      0.147     0.515 r  copy0/fsm/out[2]_i_4/O
                         net (fo=1, routed)           0.009     0.524    copy0/fsm/out[2]_i_4_n_0
    SLICE_X21Y99         MUXF7 (Prop_F7MUX_GH_SLICEL_I1_O)
                                                      0.082     0.606 r  copy0/fsm/out_reg[2]_i_1/O
                         net (fo=3, estimated)        0.344     0.950    copy0/fsm/fsm_write_en
    SLICE_X21Y99         FDRE                                         r  copy0/fsm/out_reg[0]/CE
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=8, unset)            0.024     5.024    copy0/fsm/clk
    SLICE_X21Y99         FDRE                                         r  copy0/fsm/out_reg[0]/C
                         clock pessimism              0.000     5.024    
                         clock uncertainty           -0.035     4.989    
    SLICE_X21Y99         FDRE (Setup_AFF_SLICEL_C_CE)
                                                     -0.042     4.947    copy0/fsm/out_reg[0]
  -------------------------------------------------------------------
                         required time                          4.947    
                         arrival time                          -0.950    
  -------------------------------------------------------------------
                         slack                                  3.997    




