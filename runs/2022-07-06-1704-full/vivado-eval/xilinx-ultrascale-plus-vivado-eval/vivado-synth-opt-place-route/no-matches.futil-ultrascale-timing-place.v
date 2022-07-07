Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:14:00 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//no-matches.futil-ultrascale-timing-place.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack (MET) :             0.509ns  (required time - arrival time)
  Source:                 tcam/pd43/out_reg[0]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            tcam/me18/r/out_reg[0]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        4.471ns  (logic 1.402ns (31.358%)  route 3.069ns (68.642%))
  Logic Levels:           15  (CARRY8=5 LUT4=3 LUT5=3 LUT6=4)
  Clock Path Skew:        -0.012ns (DCD - SCD + CPR)
    Destination Clock Delay (DCD):    0.025ns = ( 5.025 - 5.000 ) 
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
                         net (fo=1026, unset)         0.037     0.037    tcam/pd43/clk
    SLICE_X29Y123        FDRE                                         r  tcam/pd43/out_reg[0]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X29Y123        FDRE (Prop_CFF_SLICEM_C_Q)
                                                      0.095     0.132 f  tcam/pd43/out_reg[0]/Q
                         net (fo=10, estimated)       0.370     0.502    tcam/pd52/pd43_out
    SLICE_X29Y112        LUT4 (Prop_B6LUT_SLICEM_I2_O)
                                                      0.063     0.565 r  tcam/pd52/A_LUT_0_i_12/O
                         net (fo=1, estimated)        0.256     0.821    tcam/pd33/A_LUT_0_i_4__31
    SLICE_X28Y106        LUT5 (Prop_C6LUT_SLICEM_I4_O)
                                                      0.038     0.859 f  tcam/pd33/A_LUT_0_i_7__0/O
                         net (fo=1, estimated)        0.225     1.084    tcam/pd49/out_reg[0]_1
    SLICE_X24Y106        LUT4 (Prop_B6LUT_SLICEM_I1_O)
                                                      0.100     1.184 f  tcam/pd49/A_LUT_0_i_4__31/O
                         net (fo=69, estimated)       0.177     1.361    tcam/fsm32/A_LUT_0
    SLICE_X25Y106        LUT5 (Prop_C5LUT_SLICEL_I0_O)
                                                      0.083     1.444 f  tcam/fsm32/A_LUT_0_i_3__18/O
                         net (fo=70, estimated)       0.665     2.109    tcam/fsm32/out_reg[3]_8
    SLICE_X17Y92         LUT4 (Prop_D6LUT_SLICEL_I0_O)
                                                      0.063     2.172 r  tcam/fsm32/B_LUT_1_i_1__35/O
                         net (fo=2, estimated)        0.167     2.339    tcam/me18/sub/_impl/B_LUT_1/I1
    SLICE_X17Y91         LUT6 (Prop_B6LUT_SLICEL_I1_O)
                                                      0.149     2.488 r  tcam/me18/sub/_impl/B_LUT_1/LUT6/O
                         net (fo=1, routed)           0.010     2.498    tcam/me18/sub/_impl/luts_O6_1[1]
    SLICE_X17Y91         CARRY8 (Prop_CARRY8_SLICEL_S[1]_O[4])
                                                      0.250     2.748 f  tcam/me18/sub/_impl/carry_8/O[4]
                         net (fo=19, estimated)       0.299     3.047    tcam/fsm33/B_LUT_1_16[0]
    SLICE_X16Y87         LUT6 (Prop_E6LUT_SLICEM_I4_O)
                                                      0.039     3.086 f  tcam/fsm33/B_LUT_1_i_2__17/O
                         net (fo=7, estimated)        0.247     3.333    tcam/me18/sub/_impl/B_LUT_1_0
    SLICE_X16Y84         LUT6 (Prop_B6LUT_SLICEM_I4_O)
                                                      0.039     3.372 f  tcam/me18/sub/_impl/F_LUT_5_i_1__17/O
                         net (fo=2, estimated)        0.175     3.547    tcam/me18/eq/_impl/F_LUT_5/I0
    SLICE_X17Y84         LUT6 (Prop_F6LUT_SLICEL_I0_O)
                                                      0.177     3.724 r  tcam/me18/eq/_impl/F_LUT_5/LUT6/O
                         net (fo=1, routed)           0.012     3.736    tcam/me18/eq/_impl/luts_O6_1[5]
    SLICE_X17Y84         CARRY8 (Prop_CARRY8_SLICEL_S[5]_CO[7])
                                                      0.197     3.933 r  tcam/me18/eq/_impl/carry_8/CO[7]
                         net (fo=1, estimated)        0.028     3.961    tcam/me18/eq/_impl/co_3[7]
    SLICE_X17Y85         CARRY8 (Prop_CARRY8_SLICEL_CI_CO[7])
                                                      0.023     3.984 r  tcam/me18/eq/_impl/carry_17/CO[7]
                         net (fo=1, estimated)        0.028     4.012    tcam/me18/eq/_impl/co_7[7]
    SLICE_X17Y86         CARRY8 (Prop_CARRY8_SLICEL_CI_CO[7])
                                                      0.023     4.035 r  tcam/me18/eq/_impl/carry_26/CO[7]
                         net (fo=1, estimated)        0.028     4.063    tcam/me18/eq/_impl/co_11[7]
    SLICE_X17Y87         CARRY8 (Prop_CARRY8_SLICEL_CI_CO[7])
                                                      0.023     4.086 r  tcam/me18/eq/_impl/carry_35/CO[7]
                         net (fo=1, estimated)        0.322     4.408    tcam/me18/r/out0
    SLICE_X17Y90         LUT5 (Prop_H6LUT_SLICEL_I0_O)
                                                      0.040     4.448 r  tcam/me18/r/out[0]_i_1__17/O
                         net (fo=1, routed)           0.060     4.508    tcam/me18/r/out[0]_i_1__17_n_0
    SLICE_X17Y90         FDRE                                         r  tcam/me18/r/out_reg[0]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=1026, unset)         0.025     5.025    tcam/me18/r/clk
    SLICE_X17Y90         FDRE                                         r  tcam/me18/r/out_reg[0]/C
                         clock pessimism              0.000     5.025    
                         clock uncertainty           -0.035     4.990    
    SLICE_X17Y90         FDRE (Setup_HFF_SLICEL_C_D)
                                                      0.027     5.017    tcam/me18/r/out_reg[0]
  -------------------------------------------------------------------
                         required time                          5.017    
                         arrival time                          -4.508    
  -------------------------------------------------------------------
                         slack                                  0.509    




