Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:08:02 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//lpm.futil-vanilla-timing-place.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack (MET) :             1.911ns  (required time - arrival time)
  Source:                 tcam/pd55/out_reg[0]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            tcam/me1/r/out_reg[0]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        3.070ns  (logic 1.074ns (34.984%)  route 1.996ns (65.016%))
  Logic Levels:           7  (CARRY8=1 LUT4=2 LUT5=3 LUT6=1)
  Clock Path Skew:        -0.011ns (DCD - SCD + CPR)
    Destination Clock Delay (DCD):    0.025ns = ( 5.025 - 5.000 ) 
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
                         net (fo=653, unset)          0.036     0.036    tcam/pd55/clk
    SLICE_X33Y22         FDRE                                         r  tcam/pd55/out_reg[0]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X33Y22         FDRE (Prop_GFF_SLICEL_C_Q)
                                                      0.097     0.133 r  tcam/pd55/out_reg[0]/Q
                         net (fo=4, estimated)        0.230     0.363    tcam/pd55/pd55_out
    SLICE_X33Y28         LUT4 (Prop_B5LUT_SLICEL_I0_O)
                                                      0.202     0.565 r  tcam/pd55/done_i_10/O
                         net (fo=1, estimated)        0.248     0.813    tcam/pd36/done_i_3__2
    SLICE_X32Y26         LUT5 (Prop_E6LUT_SLICEL_I4_O)
                                                      0.039     0.852 r  tcam/pd36/done_i_6/O
                         net (fo=1, estimated)        0.191     1.043    tcam/pd61/out_reg[0]_0
    SLICE_X32Y20         LUT4 (Prop_C6LUT_SLICEL_I1_O)
                                                      0.098     1.141 r  tcam/pd61/done_i_3__2/O
                         net (fo=63, estimated)       0.536     1.677    tcam/l1/par0_done_in
    SLICE_X33Y35         LUT5 (Prop_D5LUT_SLICEL_I2_O)
                                                      0.080     1.757 r  tcam/l1/out_carry_i_15__0/O
                         net (fo=1, estimated)        0.211     1.968    tcam/fsm32/out_carry_6
    SLICE_X33Y36         LUT6 (Prop_A6LUT_SLICEL_I0_O)
                                                      0.178     2.146 r  tcam/fsm32/out_carry_i_8__0/O
                         net (fo=1, routed)           0.011     2.157    tcam/me1/eq/S[0]
    SLICE_X33Y36         CARRY8 (Prop_CARRY8_SLICEL_S[0]_CO[7])
                                                      0.238     2.395 r  tcam/me1/eq/out_carry/CO[7]
                         net (fo=1, estimated)        0.228     2.623    tcam/me1/r/CO[0]
    SLICE_X33Y34         LUT5 (Prop_B5LUT_SLICEL_I0_O)
                                                      0.142     2.765 r  tcam/me1/r/out[0]_i_1__0/O
                         net (fo=1, estimated)        0.341     3.106    tcam/me1/r/out[0]_i_1__0_n_0
    SLICE_X33Y34         FDRE                                         r  tcam/me1/r/out_reg[0]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=653, unset)          0.025     5.025    tcam/me1/r/clk
    SLICE_X33Y34         FDRE                                         r  tcam/me1/r/out_reg[0]/C
                         clock pessimism              0.000     5.025    
                         clock uncertainty           -0.035     4.990    
    SLICE_X33Y34         FDRE (Setup_EFF_SLICEL_C_D)
                                                      0.027     5.017    tcam/me1/r/out_reg[0]
  -------------------------------------------------------------------
                         required time                          5.017    
                         arrival time                          -3.106    
  -------------------------------------------------------------------
                         slack                                  1.911    




