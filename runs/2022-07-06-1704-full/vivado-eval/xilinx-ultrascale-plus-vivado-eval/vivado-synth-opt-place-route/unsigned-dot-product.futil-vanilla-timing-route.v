Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 02:25:14 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//unsigned-dot-product.futil-vanilla-timing-route.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack (MET) :             4.126ns  (required time - arrival time)
  Source:                 r_2/done_reg/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            fsm/out_reg[2]/CE
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        0.785ns  (logic 0.361ns (45.987%)  route 0.424ns (54.013%))
  Logic Levels:           2  (LUT4=1 LUT5=1)
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
                         net (fo=13, unset)           0.036     0.036    r_2/clk
    SLICE_X26Y89         FDRE                                         r  r_2/done_reg/C
  -------------------------------------------------------------------    -------------------
    SLICE_X26Y89         FDRE (Prop_HFF_SLICEL_C_Q)
                                                      0.096     0.132 r  r_2/done_reg/Q
                         net (fo=4, routed)           0.124     0.256    r_2/r_2_done
    SLICE_X27Y89         LUT4 (Prop_B5LUT_SLICEL_I0_O)
                                                      0.202     0.458 r  r_2/out[2]_i_3/O
                         net (fo=1, routed)           0.136     0.594    fsm/out_reg[0]_2
    SLICE_X26Y89         LUT5 (Prop_G6LUT_SLICEL_I2_O)
                                                      0.063     0.657 r  fsm/out[2]_i_1__0/O
                         net (fo=3, routed)           0.164     0.821    fsm/fsm_write_en
    SLICE_X27Y89         FDRE                                         r  fsm/out_reg[2]/CE
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=13, unset)           0.025     5.025    fsm/clk
    SLICE_X27Y89         FDRE                                         r  fsm/out_reg[2]/C
                         clock pessimism              0.000     5.025    
                         clock uncertainty           -0.035     4.990    
    SLICE_X27Y89         FDRE (Setup_HFF_SLICEL_C_CE)
                                                     -0.043     4.947    fsm/out_reg[2]
  -------------------------------------------------------------------
                         required time                          4.947    
                         arrival time                          -0.821    
  -------------------------------------------------------------------
                         slack                                  4.126    




