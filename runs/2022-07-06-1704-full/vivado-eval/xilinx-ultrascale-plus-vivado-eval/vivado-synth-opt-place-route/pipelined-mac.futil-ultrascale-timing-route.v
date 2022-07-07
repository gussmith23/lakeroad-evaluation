Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 02:32:55 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//pipelined-mac.futil-ultrascale-timing-route.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack (MET) :             2.152ns  (required time - arrival time)
  Source:                 fsm/out_reg[2]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            mac/pipe2/out_reg[31]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        2.828ns  (logic 1.164ns (41.160%)  route 1.664ns (58.840%))
  Logic Levels:           8  (CARRY8=4 LUT2=1 LUT4=1 LUT6=2)
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
                         net (fo=196, unset)          0.037     0.037    fsm/clk
    SLICE_X16Y11         FDRE                                         r  fsm/out_reg[2]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X16Y11         FDRE (Prop_CFF_SLICEM_C_Q)
                                                      0.095     0.132 f  fsm/out_reg[2]/Q
                         net (fo=19, routed)          0.306     0.438    fsm/out_reg[2]_1[2]
    SLICE_X18Y11         LUT4 (Prop_D5LUT_SLICEL_I0_O)
                                                      0.193     0.631 r  fsm/done_buf[0]_i_2/O
                         net (fo=15, routed)          0.287     0.918    mac/fsm0/out_reg[31]_0
    SLICE_X17Y12         LUT6 (Prop_E6LUT_SLICEL_I5_O)
                                                      0.148     1.066 r  mac/fsm0/out[31]_i_1__0/O
                         net (fo=65, routed)          0.597     1.663    mac/fsm0/stage2_go_in
    SLICE_X20Y3          LUT2 (Prop_D5LUT_SLICEM_I0_O)
                                                      0.167     1.830 r  mac/fsm0/D_LUT_3_i_1/O
                         net (fo=2, routed)           0.349     2.179    mac/add/_impl/D_LUT_3/I0
    SLICE_X23Y3          LUT6 (Prop_D6LUT_SLICEL_I0_O)
                                                      0.174     2.353 r  mac/add/_impl/D_LUT_3/LUT6/O
                         net (fo=1, routed)           0.010     2.363    mac/add/_impl/luts_O6_1[3]
    SLICE_X23Y3          CARRY8 (Prop_CARRY8_SLICEL_S[3]_CO[7])
                                                      0.195     2.558 r  mac/add/_impl/carry_8/CO[7]
                         net (fo=1, routed)           0.028     2.586    mac/add/_impl/co_3[7]
    SLICE_X23Y4          CARRY8 (Prop_CARRY8_SLICEL_CI_CO[7])
                                                      0.023     2.609 r  mac/add/_impl/carry_17/CO[7]
                         net (fo=1, routed)           0.028     2.637    mac/add/_impl/co_7[7]
    SLICE_X23Y5          CARRY8 (Prop_CARRY8_SLICEL_CI_CO[7])
                                                      0.023     2.660 r  mac/add/_impl/carry_26/CO[7]
                         net (fo=1, routed)           0.028     2.688    mac/add/_impl/co_11[7]
    SLICE_X23Y6          CARRY8 (Prop_CARRY8_SLICEL_CI_O[7])
                                                      0.146     2.834 r  mac/add/_impl/carry_35/O[7]
                         net (fo=1, routed)           0.031     2.865    mac/pipe2/D[31]
    SLICE_X23Y6          FDRE                                         r  mac/pipe2/out_reg[31]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=196, unset)          0.025     5.025    mac/pipe2/clk
    SLICE_X23Y6          FDRE                                         r  mac/pipe2/out_reg[31]/C
                         clock pessimism              0.000     5.025    
                         clock uncertainty           -0.035     4.990    
    SLICE_X23Y6          FDRE (Setup_HFF_SLICEL_C_D)
                                                      0.027     5.017    mac/pipe2/out_reg[31]
  -------------------------------------------------------------------
                         required time                          5.017    
                         arrival time                          -2.865    
  -------------------------------------------------------------------
                         slack                                  2.152    




