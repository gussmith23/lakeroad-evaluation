Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 02:54:32 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//std-sdiv.futil-vanilla-timing-route.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack (MET) :             2.367ns  (required time - arrival time)
  Source:                 div/comp/done_reg/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            div/comp/dividend_reg[31]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        2.615ns  (logic 1.205ns (46.080%)  route 1.410ns (53.920%))
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
                         net (fo=70, routed)          0.240     0.372    fsm/div_done
    SLICE_X22Y89         LUT6 (Prop_H6LUT_SLICEL_I0_O)
                                                      0.179     0.551 r  fsm/dividend[15]_i_35/O
                         net (fo=1, routed)           0.463     1.014    fsm/dividend[15]_i_35_n_0
    SLICE_X22Y90         CARRY8 (Prop_CARRY8_SLICEL_S[0]_CO[7])
                                                      0.238     1.252 r  fsm/dividend_reg[15]_i_26/CO[7]
                         net (fo=1, routed)           0.028     1.280    fsm/dividend_reg[15]_i_26_n_0
    SLICE_X22Y91         CARRY8 (Prop_CARRY8_SLICEL_CI_O[1])
                                                      0.097     1.377 r  fsm/dividend_reg[23]_i_26/O[1]
                         net (fo=2, routed)           0.354     1.731    comb_reg0/left_abs0[9]
    SLICE_X23Y89         LUT4 (Prop_H6LUT_SLICEL_I0_O)
                                                      0.116     1.847 r  comb_reg0/dividend[15]_i_23/O
                         net (fo=1, routed)           0.227     2.074    div/comp/left_abs[9]
    SLICE_X23Y93         LUT4 (Prop_C6LUT_SLICEL_I1_O)
                                                      0.113     2.187 r  div/comp/dividend[15]_i_15/O
                         net (fo=1, routed)           0.011     2.198    fsm/dividend_reg[15][2]
    SLICE_X23Y93         CARRY8 (Prop_CARRY8_SLICEL_S[2]_CO[7])
                                                      0.196     2.394 r  fsm/dividend_reg[15]_i_1/CO[7]
                         net (fo=1, routed)           0.028     2.422    fsm/dividend_reg[15]_i_1_n_0
    SLICE_X23Y94         CARRY8 (Prop_CARRY8_SLICEL_CI_CO[7])
                                                      0.023     2.445 r  fsm/dividend_reg[23]_i_1/CO[7]
                         net (fo=1, routed)           0.028     2.473    fsm/dividend_reg[23]_i_1_n_0
    SLICE_X23Y95         CARRY8 (Prop_CARRY8_SLICEL_CI_O[7])
                                                      0.146     2.619 r  fsm/dividend_reg[31]_i_2/O[7]
                         net (fo=1, routed)           0.031     2.650    div/comp/dividend_reg[31]_1[31]
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
                         arrival time                          -2.650    
  -------------------------------------------------------------------
                         slack                                  2.367    




