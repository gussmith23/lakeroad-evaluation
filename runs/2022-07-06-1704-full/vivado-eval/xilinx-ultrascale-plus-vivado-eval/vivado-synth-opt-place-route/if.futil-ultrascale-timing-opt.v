Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:32:02 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//if.futil-ultrascale-timing-opt.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack (MET) :             3.677ns  (required time - arrival time)
  Source:                 fsm/out_reg[0]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            comb_reg/out_reg[0]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        1.315ns  (logic 0.571ns (43.422%)  route 0.744ns (56.578%))
  Logic Levels:           7  (CARRY8=4 LUT4=1 LUT5=1 LUT6=1)
  Clock Uncertainty:      0.035ns  ((TSJ^2 + TIJ^2)^1/2 + DJ) / 2 + PE
    Total System Jitter     (TSJ):    0.071ns
    Total Input Jitter      (TIJ):    0.000ns
    Discrete Jitter          (DJ):    0.000ns
    Phase Error              (PE):    0.000ns

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=3, unset)            0.000     0.000    fsm/clk
                         FDRE                                         r  fsm/out_reg[0]/C
  -------------------------------------------------------------------    -------------------
                         FDRE (Prop_FDRE_C_Q)         0.093     0.093 r  fsm/out_reg[0]/Q
                         net (fo=9, unplaced)         0.139     0.232    fsm/Q[0]
                         LUT4 (Prop_LUT4_I0_O)        0.116     0.348 f  fsm/A_LUT_0_i_1/O
                         net (fo=4, unplaced)         0.222     0.570    lt/_impl/C_LUT_2/I0
                         LUT5 (Prop_LUT5_I0_O)        0.084     0.654 r  lt/_impl/C_LUT_2/LUT5/O
                         net (fo=1, unplaced)         0.280     0.934    lt/_impl/luts_O5_0[2]
                         CARRY8 (Prop_CARRY8_DI[2]_CO[7])
                                                      0.148     1.082 r  lt/_impl/carry_8/CO[7]
                         net (fo=1, unplaced)         0.007     1.089    lt/_impl/co_3[7]
                         CARRY8 (Prop_CARRY8_CI_CO[7])
                                                      0.030     1.119 r  lt/_impl/carry_17/CO[7]
                         net (fo=1, unplaced)         0.007     1.126    lt/_impl/co_7[7]
                         CARRY8 (Prop_CARRY8_CI_CO[7])
                                                      0.030     1.156 r  lt/_impl/carry_26/CO[7]
                         net (fo=1, unplaced)         0.007     1.163    lt/_impl/co_11[7]
                         CARRY8 (Prop_CARRY8_CI_CO[7])
                                                      0.030     1.193 r  lt/_impl/carry_35/CO[7]
                         net (fo=1, unplaced)         0.024     1.217    fsm/out0
                         LUT6 (Prop_LUT6_I0_O)        0.040     1.257 r  fsm/out[0]_i_1/O
                         net (fo=1, unplaced)         0.058     1.315    comb_reg/out_reg[0]_0
                         FDRE                                         r  comb_reg/out_reg[0]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=3, unset)            0.000     5.000    comb_reg/clk
                         FDRE                                         r  comb_reg/out_reg[0]/C
                         clock pessimism              0.000     5.000    
                         clock uncertainty           -0.035     4.965    
                         FDRE (Setup_FDRE_C_D)        0.027     4.992    comb_reg/out_reg[0]
  -------------------------------------------------------------------
                         required time                          4.992    
                         arrival time                          -1.315    
  -------------------------------------------------------------------
                         slack                                  3.677    




