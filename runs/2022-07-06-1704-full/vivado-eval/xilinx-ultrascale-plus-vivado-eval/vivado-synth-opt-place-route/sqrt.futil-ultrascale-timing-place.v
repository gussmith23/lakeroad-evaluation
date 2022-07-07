Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:01:07 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//sqrt.futil-ultrascale-timing-place.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack (MET) :             3.372ns  (required time - arrival time)
  Source:                 s/comp/acc_reg[4]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            s/comp/out_reg[0]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        1.610ns  (logic 0.559ns (34.720%)  route 1.051ns (65.280%))
  Logic Levels:           7  (CARRY8=5 LUT1=1 LUT2=1)
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
    SLICE_X26Y104        FDRE                                         r  s/comp/acc_reg[4]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X26Y104        FDRE (Prop_EFF_SLICEL_C_Q)
                                                      0.096     0.132 r  s/comp/acc_reg[4]/Q
                         net (fo=3, estimated)        0.277     0.409    s/comp/acc[4]
    SLICE_X25Y102        LUT2 (Prop_D6LUT_SLICEL_I0_O)
                                                      0.063     0.472 r  s/comp/quotient_next1_carry_i_5__2/O
                         net (fo=1, routed)           0.010     0.482    s/comp/quotient_next1_carry_i_5__2_n_0
    SLICE_X25Y102        CARRY8 (Prop_CARRY8_SLICEL_S[3]_CO[7])
                                                      0.195     0.677 r  s/comp/quotient_next1_carry/CO[7]
                         net (fo=1, estimated)        0.028     0.705    s/comp/quotient_next1_carry_n_0
    SLICE_X25Y103        CARRY8 (Prop_CARRY8_SLICEL_CI_CO[7])
                                                      0.023     0.728 r  s/comp/quotient_next1_carry__0/CO[7]
                         net (fo=1, estimated)        0.028     0.756    s/comp/quotient_next1_carry__0_n_0
    SLICE_X25Y104        CARRY8 (Prop_CARRY8_SLICEL_CI_CO[7])
                                                      0.023     0.779 r  s/comp/quotient_next1_carry__1/CO[7]
                         net (fo=1, estimated)        0.028     0.807    s/comp/quotient_next1_carry__1_n_0
    SLICE_X25Y105        CARRY8 (Prop_CARRY8_SLICEL_CI_CO[7])
                                                      0.023     0.830 r  s/comp/quotient_next1_carry__2/CO[7]
                         net (fo=1, estimated)        0.028     0.858    s/comp/quotient_next1_carry__2_n_0
    SLICE_X25Y106        CARRY8 (Prop_CARRY8_SLICEL_CI_O[0])
                                                      0.072     0.930 f  s/comp/quotient_next1_carry__3/O[0]
                         net (fo=33, estimated)       0.325     1.255    s/comp/p_0_in
    SLICE_X26Y104        LUT1 (Prop_A6LUT_SLICEL_I0_O)
                                                      0.064     1.319 r  s/comp/quotient[0]_i_1/O
                         net (fo=2, estimated)        0.327     1.646    s/comp/quotient_next[0]
    SLICE_X24Y104        FDRE                                         r  s/comp/out_reg[0]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=168, unset)          0.026     5.026    s/comp/clk
    SLICE_X24Y104        FDRE                                         r  s/comp/out_reg[0]/C
                         clock pessimism              0.000     5.026    
                         clock uncertainty           -0.035     4.991    
    SLICE_X24Y104        FDRE (Setup_EFF_SLICEM_C_D)
                                                      0.027     5.018    s/comp/out_reg[0]
  -------------------------------------------------------------------
                         required time                          5.018    
                         arrival time                          -1.646    
  -------------------------------------------------------------------
                         slack                                  3.372    




