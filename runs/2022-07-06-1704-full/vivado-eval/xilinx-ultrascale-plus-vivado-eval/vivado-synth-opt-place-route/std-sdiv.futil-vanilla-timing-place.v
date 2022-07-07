Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 02:54:26 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//std-sdiv.futil-vanilla-timing-place.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack (MET) :             2.741ns  (required time - arrival time)
  Source:                 div/comp/done_reg/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            div/comp/dividend_reg[31]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        2.241ns  (logic 1.079ns (48.148%)  route 1.162ns (51.852%))
  Logic Levels:           8  (CARRY8=5 LUT4=2 LUT6=1)
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
                         net (fo=332, unset)          0.035     0.035    div/comp/clk
    SLICE_X21Y91         FDRE                                         r  div/comp/done_reg/C
  -------------------------------------------------------------------    -------------------
    SLICE_X21Y91         FDRE (Prop_CFF_SLICEL_C_Q)
                                                      0.097     0.132 r  div/comp/done_reg/Q
                         net (fo=70, estimated)       0.280     0.412    fsm/div_done
    SLICE_X22Y89         LUT6 (Prop_H6LUT_SLICEL_I0_O)
                                                      0.179     0.591 r  fsm/dividend[15]_i_35/O
                         net (fo=1, estimated)        0.239     0.830    fsm/dividend[15]_i_35_n_0
    SLICE_X22Y90         CARRY8 (Prop_CARRY8_SLICEL_S[0]_CO[7])
                                                      0.238     1.068 r  fsm/dividend_reg[15]_i_26/CO[7]
                         net (fo=1, estimated)        0.028     1.096    fsm/dividend_reg[15]_i_26_n_0
    SLICE_X22Y91         CARRY8 (Prop_CARRY8_SLICEL_CI_CO[7])
                                                      0.023     1.119 r  fsm/dividend_reg[23]_i_26/CO[7]
                         net (fo=1, estimated)        0.028     1.147    fsm/dividend_reg[23]_i_26_n_0
    SLICE_X22Y92         CARRY8 (Prop_CARRY8_SLICEL_CI_O[1])
                                                      0.097     1.244 r  fsm/done_reg_i_11/O[1]
                         net (fo=1, estimated)        0.346     1.590    comb_reg0/left_abs0[17]
    SLICE_X23Y90         LUT4 (Prop_B6LUT_SLICEL_I0_O)
                                                      0.040     1.630 r  comb_reg0/dividend[23]_i_23/O
                         net (fo=2, estimated)        0.171     1.801    div/comp/left_abs[17]
    SLICE_X23Y94         LUT4 (Prop_C6LUT_SLICEL_I1_O)
                                                      0.063     1.864 r  div/comp/dividend[23]_i_15/O
                         net (fo=1, routed)           0.011     1.875    fsm/dividend_reg[23][2]
    SLICE_X23Y94         CARRY8 (Prop_CARRY8_SLICEL_S[2]_CO[7])
                                                      0.196     2.071 r  fsm/dividend_reg[23]_i_1/CO[7]
                         net (fo=1, estimated)        0.028     2.099    fsm/dividend_reg[23]_i_1_n_0
    SLICE_X23Y95         CARRY8 (Prop_CARRY8_SLICEL_CI_O[7])
                                                      0.146     2.245 r  fsm/dividend_reg[31]_i_2/O[7]
                         net (fo=1, routed)           0.031     2.276    div/comp/dividend_reg[31]_1[31]
    SLICE_X23Y95         FDRE                                         r  div/comp/dividend_reg[31]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=332, unset)          0.025     5.025    div/comp/clk
    SLICE_X23Y95         FDRE                                         r  div/comp/dividend_reg[31]/C
                         clock pessimism              0.000     5.025    
                         clock uncertainty           -0.035     4.990    
    SLICE_X23Y95         FDRE (Setup_HFF_SLICEL_C_D)
                                                      0.027     5.017    div/comp/dividend_reg[31]
  -------------------------------------------------------------------
                         required time                          5.017    
                         arrival time                          -2.276    
  -------------------------------------------------------------------
                         slack                                  2.741    




