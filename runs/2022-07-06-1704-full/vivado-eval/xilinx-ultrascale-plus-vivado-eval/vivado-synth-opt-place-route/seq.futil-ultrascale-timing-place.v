Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:21:46 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//seq.futil-ultrascale-timing-place.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack (MET) :             3.982ns  (required time - arrival time)
  Source:                 c/done_reg/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            c/out_reg[2]/CE
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        0.928ns  (logic 0.261ns (28.125%)  route 0.667ns (71.875%))
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
                         net (fo=67, unset)           0.037     0.037    c/clk
    SLICE_X24Y95         FDRE                                         r  c/done_reg/C
  -------------------------------------------------------------------    -------------------
    SLICE_X24Y95         FDRE (Prop_CFF2_SLICEM_C_Q)
                                                      0.094     0.131 f  c/done_reg/Q
                         net (fo=3, estimated)        0.253     0.384    fsm/c_done
    SLICE_X24Y95         LUT4 (Prop_H5LUT_SLICEM_I3_O)
                                                      0.167     0.551 r  fsm/out[31]_i_1/O
                         net (fo=33, estimated)       0.414     0.965    c/E[0]
    SLICE_X24Y96         FDRE                                         r  c/out_reg[2]/CE
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=67, unset)           0.026     5.026    c/clk
    SLICE_X24Y96         FDRE                                         r  c/out_reg[2]/C
                         clock pessimism              0.000     5.026    
                         clock uncertainty           -0.035     4.991    
    SLICE_X24Y96         FDRE (Setup_HFF_SLICEM_C_CE)
                                                     -0.044     4.947    c/out_reg[2]
  -------------------------------------------------------------------
                         required time                          4.947    
                         arrival time                          -0.965    
  -------------------------------------------------------------------
                         slack                                  3.982    




