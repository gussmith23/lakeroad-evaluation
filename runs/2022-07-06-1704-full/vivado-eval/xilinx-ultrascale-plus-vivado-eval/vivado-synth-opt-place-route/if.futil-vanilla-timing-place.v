Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:30:53 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//if.futil-vanilla-timing-place.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack (MET) :             4.252ns  (required time - arrival time)
  Source:                 fsm/out_reg[1]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            fsm/out_reg[0]/CE
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        0.659ns  (logic 0.245ns (37.178%)  route 0.414ns (62.822%))
  Logic Levels:           1  (LUT5=1)
  Clock Path Skew:        -0.011ns (DCD - SCD + CPR)
    Destination Clock Delay (DCD):    0.025ns = ( 5.025 - 5.000 ) 
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
                         net (fo=3, unset)            0.036     0.036    fsm/clk
    SLICE_X26Y90         FDRE                                         r  fsm/out_reg[1]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X26Y90         FDRE (Prop_HFF_SLICEL_C_Q)
                                                      0.096     0.132 r  fsm/out_reg[1]/Q
                         net (fo=9, estimated)        0.203     0.335    fsm/Q[1]
    SLICE_X26Y90         LUT5 (Prop_A6LUT_SLICEL_I1_O)
                                                      0.149     0.484 r  fsm/out[1]_i_1/O
                         net (fo=2, estimated)        0.211     0.695    fsm/fsm_write_en
    SLICE_X26Y90         FDRE                                         r  fsm/out_reg[0]/CE
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=3, unset)            0.025     5.025    fsm/clk
    SLICE_X26Y90         FDRE                                         r  fsm/out_reg[0]/C
                         clock pessimism              0.000     5.025    
                         clock uncertainty           -0.035     4.990    
    SLICE_X26Y90         FDRE (Setup_GFF_SLICEL_C_CE)
                                                     -0.043     4.947    fsm/out_reg[0]
  -------------------------------------------------------------------
                         required time                          4.947    
                         arrival time                          -0.695    
  -------------------------------------------------------------------
                         slack                                  4.252    




