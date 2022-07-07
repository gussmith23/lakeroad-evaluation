Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:15:19 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//while.futil-vanilla-timing-opt.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack (MET) :             3.566ns  (required time - arrival time)
  Source:                 fsm/out_reg[0]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            comb_reg/out_reg[0]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        1.426ns  (logic 0.733ns (51.403%)  route 0.693ns (48.597%))
  Logic Levels:           5  (CARRY8=2 LUT3=2 LUT5=1)
  Clock Uncertainty:      0.035ns  ((TSJ^2 + TIJ^2)^1/2 + DJ) / 2 + PE
    Total System Jitter     (TSJ):    0.071ns
    Total Input Jitter      (TIJ):    0.000ns
    Discrete Jitter          (DJ):    0.000ns
    Phase Error              (PE):    0.000ns

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=4, unset)            0.000     0.000    fsm/clk
                         FDRE                                         r  fsm/out_reg[0]/C
  -------------------------------------------------------------------    -------------------
                         FDRE (Prop_FDRE_C_Q)         0.093     0.093 r  fsm/out_reg[0]/Q
                         net (fo=73, unplaced)        0.192     0.285    fsm/fsm_out[0]
                         LUT5 (Prop_LUT5_I0_O)        0.200     0.485 r  fsm/out_carry_i_10/O
                         net (fo=16, unplaced)        0.254     0.739    fsm/out_reg[0]_0
                         LUT3 (Prop_LUT3_I2_O)        0.039     0.778 r  fsm/out_carry_i_8/O
                         net (fo=1, unplaced)         0.025     0.803    lt/out_carry__0_0[1]
                         CARRY8 (Prop_CARRY8_S[1]_CO[7])
                                                      0.245     1.048 r  lt/out_carry/CO[7]
                         net (fo=1, unplaced)         0.007     1.055    lt/out_carry_n_0
                         CARRY8 (Prop_CARRY8_CI_CO[6])
                                                      0.116     1.171 r  lt/out_carry__0/CO[6]
                         net (fo=1, unplaced)         0.157     1.328    comb_reg/CO[0]
                         LUT3 (Prop_LUT3_I2_O)        0.040     1.368 r  comb_reg/out[0]_i_1__0/O
                         net (fo=1, unplaced)         0.058     1.426    comb_reg/out[0]_i_1__0_n_0
                         FDRE                                         r  comb_reg/out_reg[0]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=4, unset)            0.000     5.000    comb_reg/clk
                         FDRE                                         r  comb_reg/out_reg[0]/C
                         clock pessimism              0.000     5.000    
                         clock uncertainty           -0.035     4.965    
                         FDRE (Setup_FDRE_C_D)        0.027     4.992    comb_reg/out_reg[0]
  -------------------------------------------------------------------
                         required time                          4.992    
                         arrival time                          -1.426    
  -------------------------------------------------------------------
                         slack                                  3.566    




