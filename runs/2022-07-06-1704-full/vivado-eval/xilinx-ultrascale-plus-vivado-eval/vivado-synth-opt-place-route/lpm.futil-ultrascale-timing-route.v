Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:10:20 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//lpm.futil-ultrascale-timing-route.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack (MET) :             0.471ns  (required time - arrival time)
  Source:                 tcam/pd52/out_reg[0]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            tcam/me31/r/out_reg[0]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        4.508ns  (logic 1.746ns (38.731%)  route 2.762ns (61.269%))
  Logic Levels:           15  (CARRY8=5 LUT4=3 LUT5=4 LUT6=3)
  Clock Path Skew:        -0.013ns (DCD - SCD + CPR)
    Destination Clock Delay (DCD):    0.024ns = ( 5.024 - 5.000 ) 
    Source Clock Delay      (SCD):    0.037ns
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
                         net (fo=1076, unset)         0.037     0.037    tcam/pd52/clk
    SLICE_X28Y67         FDRE                                         r  tcam/pd52/out_reg[0]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X28Y67         FDRE (Prop_AFF_SLICEM_C_Q)
                                                      0.093     0.130 f  tcam/pd52/out_reg[0]/Q
                         net (fo=31, routed)          0.185     0.315    tcam/pd51/pd52_out
    SLICE_X27Y66         LUT4 (Prop_A6LUT_SLICEL_I1_O)
                                                      0.149     0.464 r  tcam/pd51/A_LUT_0_i_13__0/O
                         net (fo=1, routed)           0.167     0.631    tcam/pd50/A_LUT_0_i_4__63
    SLICE_X27Y61         LUT5 (Prop_H6LUT_SLICEL_I4_O)
                                                      0.040     0.671 r  tcam/pd50/A_LUT_0_i_8/O
                         net (fo=1, routed)           0.170     0.841    tcam/pd61/out_reg[0]_2
    SLICE_X23Y61         LUT4 (Prop_E6LUT_SLICEL_I2_O)
                                                      0.064     0.905 f  tcam/pd61/A_LUT_0_i_4__63/O
                         net (fo=78, routed)          0.362     1.267    tcam/fsm32/par0_done_in
    SLICE_X24Y53         LUT5 (Prop_G6LUT_SLICEM_I0_O)
                                                      0.039     1.306 r  tcam/fsm32/A_LUT_0_i_3__55/O
                         net (fo=77, routed)          0.462     1.768    tcam/l31/out_reg[0]_6_alias
    SLICE_X26Y42         LUT4 (Prop_H6LUT_SLICEL_I3_O)
                                                      0.100     1.868 r  tcam/l31/B_LUT_1_i_1__61/O
                         net (fo=2, routed)           0.223     2.091    tcam/me31/sub/_impl/B_LUT_1/I1
    SLICE_X26Y40         LUT6 (Prop_B6LUT_SLICEL_I1_O)
                                                      0.149     2.240 r  tcam/me31/sub/_impl/B_LUT_1/LUT6/O
                         net (fo=1, routed)           0.010     2.250    tcam/me31/sub/_impl/luts_O6_1[1]
    SLICE_X26Y40         CARRY8 (Prop_CARRY8_SLICEL_S[1]_O[4])
                                                      0.250     2.500 r  tcam/me31/sub/_impl/carry_8/O[4]
                         net (fo=23, routed)          0.261     2.761    tcam/me31/sub/_impl/sub_out[4]
    SLICE_X26Y35         LUT5 (Prop_D5LUT_SLICEL_I4_O)
                                                      0.164     2.925 r  tcam/me31/sub/_impl/D_LUT_3_i_3__30/O
                         net (fo=8, routed)           0.346     3.271    tcam/me31/sub/_impl/D_LUT_3_i_3__30_n_0
    SLICE_X25Y31         LUT6 (Prop_H6LUT_SLICEL_I1_O)
                                                      0.179     3.450 r  tcam/me31/sub/_impl/D_LUT_3_i_1__62/O
                         net (fo=2, routed)           0.251     3.701    tcam/me31/eq/_impl/D_LUT_3/I0
    SLICE_X24Y30         LUT6 (Prop_D6LUT_SLICEM_I0_O)
                                                      0.174     3.875 r  tcam/me31/eq/_impl/D_LUT_3/LUT6/O
                         net (fo=1, routed)           0.026     3.901    tcam/me31/eq/_impl/luts_O6_1[3]
    SLICE_X24Y30         CARRY8 (Prop_CARRY8_SLICEM_S[3]_CO[7])
                                                      0.206     4.107 r  tcam/me31/eq/_impl/carry_8/CO[7]
                         net (fo=1, routed)           0.028     4.135    tcam/me31/eq/_impl/co_3[7]
    SLICE_X24Y31         CARRY8 (Prop_CARRY8_SLICEM_CI_CO[7])
                                                      0.023     4.158 r  tcam/me31/eq/_impl/carry_17/CO[7]
                         net (fo=1, routed)           0.028     4.186    tcam/me31/eq/_impl/co_7[7]
    SLICE_X24Y32         CARRY8 (Prop_CARRY8_SLICEM_CI_CO[7])
                                                      0.023     4.209 r  tcam/me31/eq/_impl/carry_26/CO[7]
                         net (fo=1, routed)           0.028     4.237    tcam/me31/eq/_impl/co_11[7]
    SLICE_X24Y33         CARRY8 (Prop_CARRY8_SLICEM_CI_CO[7])
                                                      0.030     4.267 r  tcam/me31/eq/_impl/carry_35/CO[7]
                         net (fo=1, routed)           0.157     4.424    tcam/me31/r/out_reg[0]_1
    SLICE_X25Y33         LUT5 (Prop_D6LUT_SLICEL_I0_O)
                                                      0.063     4.487 r  tcam/me31/r/out[0]_i_1__30/O
                         net (fo=1, routed)           0.058     4.545    tcam/me31/r/out[0]_i_1__30_n_0
    SLICE_X25Y33         FDRE                                         r  tcam/me31/r/out_reg[0]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=1076, unset)         0.024     5.024    tcam/me31/r/clk
    SLICE_X25Y33         FDRE                                         r  tcam/me31/r/out_reg[0]/C
                         clock pessimism              0.000     5.024    
                         clock uncertainty           -0.035     4.989    
    SLICE_X25Y33         FDRE (Setup_DFF_SLICEL_C_D)
                                                      0.027     5.016    tcam/me31/r/out_reg[0]
  -------------------------------------------------------------------
                         required time                          5.016    
                         arrival time                          -4.545    
  -------------------------------------------------------------------
                         slack                                  0.471    




