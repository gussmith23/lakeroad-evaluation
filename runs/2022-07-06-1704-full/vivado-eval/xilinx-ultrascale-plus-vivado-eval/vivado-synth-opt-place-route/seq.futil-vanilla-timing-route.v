Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:20:34 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//seq.futil-vanilla-timing-route.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack (MET) :             3.785ns  (required time - arrival time)
  Source:                 fsm/out_reg[0]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            c/out_reg[28]/CE
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        1.125ns  (logic 0.178ns (15.822%)  route 0.947ns (84.178%))
  Logic Levels:           1  (LUT4=1)
  Clock Path Skew:        -0.011ns (DCD - SCD + CPR)
    Destination Clock Delay (DCD):    0.026ns = ( 5.026 - 5.000 ) 
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
                         net (fo=67, unset)           0.037     0.037    fsm/clk
    SLICE_X24Y95         FDRE                                         r  fsm/out_reg[0]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X24Y95         FDRE (Prop_DFF_SLICEM_C_Q)
                                                      0.096     0.133 r  fsm/out_reg[0]/Q
                         net (fo=39, routed)          0.380     0.513    fsm/fsm_out[0]
    SLICE_X24Y95         LUT4 (Prop_H5LUT_SLICEM_I1_O)
                                                      0.082     0.595 r  fsm/out[31]_i_1/O
                         net (fo=33, routed)          0.567     1.162    c/E[0]
    SLICE_X24Y95         FDRE                                         r  c/out_reg[28]/CE
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=67, unset)           0.026     5.026    c/clk
    SLICE_X24Y95         FDRE                                         r  c/out_reg[28]/C
                         clock pessimism              0.000     5.026    
                         clock uncertainty           -0.035     4.991    
    SLICE_X24Y95         FDRE (Setup_HFF_SLICEM_C_CE)
                                                     -0.044     4.947    c/out_reg[28]
  -------------------------------------------------------------------
                         required time                          4.947    
                         arrival time                          -1.162    
  -------------------------------------------------------------------
                         slack                                  3.785    




