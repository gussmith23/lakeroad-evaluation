Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:26:53 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//if-static-different-latencies.futil-ultrascale-timing-opt.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack (MET) :             4.077ns  (required time - arrival time)
  Source:                 t4/done_reg/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            fsm/out_reg[0]/CE
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        0.845ns  (logic 0.333ns (39.408%)  route 0.512ns (60.592%))
  Logic Levels:           2  (LUT5=2)
  Clock Uncertainty:      0.035ns  ((TSJ^2 + TIJ^2)^1/2 + DJ) / 2 + PE
    Total System Jitter     (TSJ):    0.071ns
    Total Input Jitter      (TIJ):    0.000ns
    Discrete Jitter          (DJ):    0.000ns
    Phase Error              (PE):    0.000ns

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=8, unset)            0.000     0.000    t4/clk
                         FDRE                                         r  t4/done_reg/C
  -------------------------------------------------------------------    -------------------
                         FDRE (Prop_FDRE_C_Q)         0.093     0.093 r  t4/done_reg/Q
                         net (fo=6, unplaced)         0.136     0.229    fsm/t4_done
                         LUT5 (Prop_LUT5_I0_O)        0.200     0.429 r  fsm/out[1]_i_3/O
                         net (fo=3, unplaced)         0.216     0.645    fsm/p_0_in
                         LUT5 (Prop_LUT5_I0_O)        0.040     0.685 r  fsm/out[1]_i_1/O
                         net (fo=2, unplaced)         0.160     0.845    fsm/fsm_write_en
                         FDRE                                         r  fsm/out_reg[0]/CE
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=8, unset)            0.000     5.000    fsm/clk
                         FDRE                                         r  fsm/out_reg[0]/C
                         clock pessimism              0.000     5.000    
                         clock uncertainty           -0.035     4.965    
                         FDRE (Setup_FDRE_C_CE)      -0.043     4.922    fsm/out_reg[0]
  -------------------------------------------------------------------
                         required time                          4.922    
                         arrival time                          -0.845    
  -------------------------------------------------------------------
                         slack                                  4.077    




