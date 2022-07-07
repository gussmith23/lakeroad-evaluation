Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:15:29 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//while.futil-vanilla-timing-route.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack (MET) :             3.381ns  (required time - arrival time)
  Source:                 fsm/out_reg[2]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            comb_reg/out_reg[0]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        1.599ns  (logic 0.915ns (57.223%)  route 0.684ns (42.777%))
  Logic Levels:           5  (CARRY8=2 LUT3=2 LUT5=1)
  Clock Path Skew:        -0.012ns (DCD - SCD + CPR)
    Destination Clock Delay (DCD):    0.024ns = ( 5.024 - 5.000 ) 
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
                         net (fo=4, unset)            0.036     0.036    fsm/clk
    SLICE_X35Y111        FDRE                                         r  fsm/out_reg[2]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X35Y111        FDRE (Prop_GFF_SLICEL_C_Q)
                                                      0.097     0.133 r  fsm/out_reg[2]/Q
                         net (fo=73, routed)          0.272     0.405    fsm/fsm_out[2]
    SLICE_X35Y112        LUT5 (Prop_D6LUT_SLICEL_I2_O)
                                                      0.174     0.579 r  fsm/out_carry_i_10/O
                         net (fo=16, routed)          0.145     0.724    fsm/out_reg[0]_0
    SLICE_X35Y114        LUT3 (Prop_B6LUT_SLICEL_I2_O)
                                                      0.177     0.901 r  fsm/out_carry_i_8/O
                         net (fo=1, routed)           0.010     0.911    lt/out_carry__0_0[1]
    SLICE_X35Y114        CARRY8 (Prop_CARRY8_SLICEL_S[1]_CO[7])
                                                      0.233     1.144 r  lt/out_carry/CO[7]
                         net (fo=1, routed)           0.028     1.172    lt/out_carry_n_0
    SLICE_X35Y115        CARRY8 (Prop_CARRY8_SLICEL_CI_CO[6])
                                                      0.116     1.288 r  lt/out_carry__0/CO[6]
                         net (fo=1, routed)           0.207     1.495    comb_reg/CO[0]
    SLICE_X35Y111        LUT3 (Prop_D5LUT_SLICEL_I2_O)
                                                      0.118     1.613 r  comb_reg/out[0]_i_1__0/O
                         net (fo=1, routed)           0.022     1.635    comb_reg/out[0]_i_1__0_n_0
    SLICE_X35Y111        FDRE                                         r  comb_reg/out_reg[0]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=4, unset)            0.024     5.024    comb_reg/clk
    SLICE_X35Y111        FDRE                                         r  comb_reg/out_reg[0]/C
                         clock pessimism              0.000     5.024    
                         clock uncertainty           -0.035     4.989    
    SLICE_X35Y111        FDRE (Setup_DFF2_SLICEL_C_D)
                                                      0.027     5.016    comb_reg/out_reg[0]
  -------------------------------------------------------------------
                         required time                          5.016    
                         arrival time                          -1.635    
  -------------------------------------------------------------------
                         slack                                  3.381    




