Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 02:55:39 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//std-sdiv.futil-ultrascale-timing-opt.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack (MET) :             3.123ns  (required time - arrival time)
  Source:                 div/comp/done_reg/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            div/comp/dividend_reg[31]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        1.869ns  (logic 1.088ns (58.213%)  route 0.781ns (41.787%))
  Logic Levels:           8  (CARRY8=5 LUT4=2 LUT6=1)
  Clock Uncertainty:      0.035ns  ((TSJ^2 + TIJ^2)^1/2 + DJ) / 2 + PE
    Total System Jitter     (TSJ):    0.071ns
    Total Input Jitter      (TIJ):    0.000ns
    Discrete Jitter          (DJ):    0.000ns
    Phase Error              (PE):    0.000ns

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=332, unset)          0.000     0.000    div/comp/clk
                         FDRE                                         r  div/comp/done_reg/C
  -------------------------------------------------------------------    -------------------
                         FDRE (Prop_FDRE_C_Q)         0.093     0.093 r  div/comp/done_reg/Q
                         net (fo=70, unplaced)        0.254     0.347    fsm/div_done
                         LUT6 (Prop_LUT6_I0_O)        0.178     0.525 r  fsm/done_i_22/O
                         net (fo=1, unplaced)         0.025     0.550    fsm/done_i_22_n_0
                         CARRY8 (Prop_CARRY8_S[1]_CO[7])
                                                      0.245     0.795 r  fsm/done_reg_i_11/CO[7]
                         net (fo=1, unplaced)         0.007     0.802    fsm/done_reg_i_11_n_0
                         CARRY8 (Prop_CARRY8_CI_CO[7])
                                                      0.030     0.832 r  fsm/dividend_reg[23]_i_26/CO[7]
                         net (fo=1, unplaced)         0.007     0.839    fsm/dividend_reg[23]_i_26_n_0
                         CARRY8 (Prop_CARRY8_CI_O[4])
                                                      0.109     0.948 r  fsm/dividend_reg[31]_i_26/O[4]
                         net (fo=2, unplaced)         0.209     1.157    comb_reg0/left_abs0[20]
                         LUT4 (Prop_LUT4_I0_O)        0.040     1.197 r  comb_reg0/dividend[23]_i_20/O
                         net (fo=1, unplaced)         0.210     1.407    div/comp/left_abs[20]
                         LUT4 (Prop_LUT4_I1_O)        0.038     1.445 r  div/comp/dividend[23]_i_12/O
                         net (fo=1, unplaced)         0.031     1.476    fsm/dividend_reg[23][5]
                         CARRY8 (Prop_CARRY8_S[5]_CO[7])
                                                      0.209     1.685 r  fsm/dividend_reg[23]_i_1/CO[7]
                         net (fo=1, unplaced)         0.007     1.692    fsm/dividend_reg[23]_i_1_n_0
                         CARRY8 (Prop_CARRY8_CI_O[7])
                                                      0.146     1.838 r  fsm/dividend_reg[31]_i_2/O[7]
                         net (fo=1, unplaced)         0.031     1.869    div/comp/dividend_reg[31]_1[31]
                         FDRE                                         r  div/comp/dividend_reg[31]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=332, unset)          0.000     5.000    div/comp/clk
                         FDRE                                         r  div/comp/dividend_reg[31]/C
                         clock pessimism              0.000     5.000    
                         clock uncertainty           -0.035     4.965    
                         FDRE (Setup_FDRE_C_D)        0.027     4.992    div/comp/dividend_reg[31]
  -------------------------------------------------------------------
                         required time                          4.992    
                         arrival time                          -1.869    
  -------------------------------------------------------------------
                         slack                                  3.123    




