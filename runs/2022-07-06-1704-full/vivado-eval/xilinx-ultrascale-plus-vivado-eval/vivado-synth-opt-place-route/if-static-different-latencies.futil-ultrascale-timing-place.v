Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:26:59 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//if-static-different-latencies.futil-ultrascale-timing-place.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack (MET) :             3.829ns  (required time - arrival time)
  Source:                 fsm/out_reg[0]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            fsm/out_reg[0]/CE
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        1.082ns  (logic 0.466ns (43.068%)  route 0.616ns (56.932%))
  Logic Levels:           2  (LUT5=2)
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
                         net (fo=8, unset)            0.036     0.036    fsm/clk
    SLICE_X32Y116        FDRE                                         r  fsm/out_reg[0]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X32Y116        FDRE (Prop_GFF_SLICEL_C_Q)
                                                      0.097     0.133 r  fsm/out_reg[0]/Q
                         net (fo=77, estimated)       0.251     0.384    fsm/fsm_out[0]
    SLICE_X32Y117        LUT5 (Prop_H5LUT_SLICEL_I3_O)
                                                      0.164     0.548 r  fsm/out[1]_i_3/O
                         net (fo=3, estimated)        0.162     0.710    fsm/p_0_in
    SLICE_X32Y116        LUT5 (Prop_F5LUT_SLICEL_I0_O)
                                                      0.205     0.915 r  fsm/out[1]_i_1/O
                         net (fo=2, estimated)        0.203     1.118    fsm/fsm_write_en
    SLICE_X32Y116        FDRE                                         r  fsm/out_reg[0]/CE
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=8, unset)            0.025     5.025    fsm/clk
    SLICE_X32Y116        FDRE                                         r  fsm/out_reg[0]/C
                         clock pessimism              0.000     5.025    
                         clock uncertainty           -0.035     4.990    
    SLICE_X32Y116        FDRE (Setup_GFF_SLICEL_C_CE)
                                                     -0.043     4.947    fsm/out_reg[0]
  -------------------------------------------------------------------
                         required time                          4.947    
                         arrival time                          -1.118    
  -------------------------------------------------------------------
                         slack                                  3.829    




