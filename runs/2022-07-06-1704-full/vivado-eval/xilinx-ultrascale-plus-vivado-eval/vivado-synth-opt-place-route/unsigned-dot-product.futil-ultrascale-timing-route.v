Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 02:26:31 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//unsigned-dot-product.futil-ultrascale-timing-route.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack (MET) :             3.498ns  (required time - arrival time)
  Source:                 fsm/out_reg[1]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            comb_reg/out_reg[0]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        1.484ns  (logic 0.737ns (49.663%)  route 0.747ns (50.337%))
  Logic Levels:           4  (CARRY8=1 LUT5=1 LUT6=2)
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
                         net (fo=13, unset)           0.035     0.035    fsm/clk
    SLICE_X26Y87         FDRE                                         r  fsm/out_reg[1]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X26Y87         FDRE (Prop_BFF_SLICEL_C_Q)
                                                      0.096     0.131 r  fsm/out_reg[1]/Q
                         net (fo=19, routed)          0.267     0.398    fsm/Q[1]
    SLICE_X27Y87         LUT5 (Prop_A6LUT_SLICEL_I0_O)
                                                      0.178     0.576 f  fsm/A_LUT_0_i_1/O
                         net (fo=2, routed)           0.195     0.771    lt0/_impl/A_LUT_0/I0
    SLICE_X27Y88         LUT6 (Prop_A6LUT_SLICEL_I0_O)
                                                      0.178     0.949 r  lt0/_impl/A_LUT_0/LUT6/O
                         net (fo=1, routed)           0.011     0.960    lt0/_impl/luts_O6_1[0]
    SLICE_X27Y88         CARRY8 (Prop_CARRY8_SLICEL_S[0]_CO[7])
                                                      0.245     1.205 r  lt0/_impl/carry_8/CO[7]
                         net (fo=1, routed)           0.214     1.419    fsm/out0
    SLICE_X26Y87         LUT6 (Prop_H6LUT_SLICEL_I0_O)
                                                      0.040     1.459 r  fsm/out[0]_i_1__1/O
                         net (fo=1, routed)           0.060     1.519    comb_reg/out_reg[0]_0
    SLICE_X26Y87         FDRE                                         r  comb_reg/out_reg[0]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=13, unset)           0.025     5.025    comb_reg/clk
    SLICE_X26Y87         FDRE                                         r  comb_reg/out_reg[0]/C
                         clock pessimism              0.000     5.025    
                         clock uncertainty           -0.035     4.990    
    SLICE_X26Y87         FDRE (Setup_HFF_SLICEL_C_D)
                                                      0.027     5.017    comb_reg/out_reg[0]
  -------------------------------------------------------------------
                         required time                          5.017    
                         arrival time                          -1.519    
  -------------------------------------------------------------------
                         slack                                  3.498    




