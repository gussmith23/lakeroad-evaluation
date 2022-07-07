Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:27:03 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//if-static-different-latencies.futil-ultrascale-timing-route.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack (MET) :             4.008ns  (required time - arrival time)
  Source:                 t4/done_reg/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            fsm/out_reg[0]/CE
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        0.904ns  (logic 0.268ns (29.646%)  route 0.636ns (70.354%))
  Logic Levels:           2  (LUT5=2)
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
                         net (fo=8, unset)            0.035     0.035    t4/clk
    SLICE_X32Y117        FDRE                                         r  t4/done_reg/C
  -------------------------------------------------------------------    -------------------
    SLICE_X32Y117        FDRE (Prop_CFF_SLICEL_C_Q)
                                                      0.097     0.132 r  t4/done_reg/Q
                         net (fo=6, routed)           0.240     0.372    fsm/t4_done
    SLICE_X32Y117        LUT5 (Prop_H5LUT_SLICEL_I0_O)
                                                      0.080     0.452 r  fsm/out[1]_i_3/O
                         net (fo=3, routed)           0.197     0.649    fsm/p_0_in
    SLICE_X32Y116        LUT5 (Prop_F5LUT_SLICEL_I0_O)
                                                      0.091     0.740 r  fsm/out[1]_i_1/O
                         net (fo=2, routed)           0.199     0.939    fsm/fsm_write_en
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
                         arrival time                          -0.939    
  -------------------------------------------------------------------
                         slack                                  4.008    




