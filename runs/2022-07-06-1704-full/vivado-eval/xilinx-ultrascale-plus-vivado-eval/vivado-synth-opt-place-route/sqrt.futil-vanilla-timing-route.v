Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 02:59:54 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//sqrt.futil-vanilla-timing-route.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack (MET) :             3.148ns  (required time - arrival time)
  Source:                 s/comp/quotient_reg[23]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            s/comp/acc_reg[16]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        1.834ns  (logic 0.761ns (41.494%)  route 1.073ns (58.506%))
  Logic Levels:           4  (CARRY8=2 LUT2=1 LUT4=1)
  Clock Path Skew:        -0.010ns (DCD - SCD + CPR)
    Destination Clock Delay (DCD):    0.026ns = ( 5.026 - 5.000 ) 
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
                         net (fo=168, unset)          0.036     0.036    s/comp/clk
    SLICE_X26Y106        FDRE                                         r  s/comp/quotient_reg[23]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X26Y106        FDRE (Prop_EFF_SLICEL_C_Q)
                                                      0.096     0.132 r  s/comp/quotient_reg[23]/Q
                         net (fo=3, routed)           0.373     0.505    s/comp/quotient[23]
    SLICE_X25Y105        LUT2 (Prop_A6LUT_SLICEL_I1_O)
                                                      0.178     0.683 r  s/comp/quotient_next1_carry_i_8__0/O
                         net (fo=1, routed)           0.011     0.694    s/comp/quotient_next1_carry_i_8__0_n_0
    SLICE_X25Y105        CARRY8 (Prop_CARRY8_SLICEL_S[0]_CO[7])
                                                      0.238     0.932 r  s/comp/quotient_next1_carry__2/CO[7]
                         net (fo=1, routed)           0.028     0.960    s/comp/quotient_next1_carry__2_n_0
    SLICE_X25Y106        CARRY8 (Prop_CARRY8_SLICEL_CI_O[0])
                                                      0.072     1.032 r  s/comp/quotient_next1_carry__3/O[0]
                         net (fo=33, routed)          0.583     1.615    s/comp/p_0_in
    SLICE_X24Y103        LUT4 (Prop_F6LUT_SLICEM_I3_O)
                                                      0.177     1.792 r  s/comp/acc[16]_i_1/O
                         net (fo=1, routed)           0.078     1.870    s/comp/acc[16]_i_1_n_0
    SLICE_X24Y103        FDRE                                         r  s/comp/acc_reg[16]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=168, unset)          0.026     5.026    s/comp/clk
    SLICE_X24Y103        FDRE                                         r  s/comp/acc_reg[16]/C
                         clock pessimism              0.000     5.026    
                         clock uncertainty           -0.035     4.991    
    SLICE_X24Y103        FDRE (Setup_FFF_SLICEM_C_D)
                                                      0.027     5.018    s/comp/acc_reg[16]
  -------------------------------------------------------------------
                         required time                          5.018    
                         arrival time                          -1.870    
  -------------------------------------------------------------------
                         slack                                  3.148    




