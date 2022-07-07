Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:32:08 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//if.futil-ultrascale-timing-place.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack (MET) :             3.295ns  (required time - arrival time)
  Source:                 comb_reg/done_reg/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            comb_reg/out_reg[0]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        1.685ns  (logic 0.777ns (46.113%)  route 0.908ns (53.887%))
  Logic Levels:           7  (CARRY8=4 LUT4=1 LUT6=2)
  Clock Path Skew:        -0.012ns (DCD - SCD + CPR)
    Destination Clock Delay (DCD):    0.024ns = ( 5.024 - 5.000 ) 
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
                         net (fo=3, unset)            0.036     0.036    comb_reg/clk
    SLICE_X26Y91         FDRE                                         r  comb_reg/done_reg/C
  -------------------------------------------------------------------    -------------------
    SLICE_X26Y91         FDRE (Prop_HFF2_SLICEL_C_Q)
                                                      0.097     0.133 r  comb_reg/done_reg/Q
                         net (fo=5, estimated)        0.255     0.388    fsm/comb_reg_done
    SLICE_X26Y91         LUT4 (Prop_B5LUT_SLICEL_I2_O)
                                                      0.202     0.590 f  fsm/A_LUT_0_i_1/O
                         net (fo=4, estimated)        0.306     0.896    lt/_impl/C_LUT_2/I0
    SLICE_X26Y87         LUT6 (Prop_C6LUT_SLICEL_I0_O)
                                                      0.174     1.070 r  lt/_impl/C_LUT_2/LUT6/O
                         net (fo=1, routed)           0.011     1.081    lt/_impl/luts_O6_1[2]
    SLICE_X26Y87         CARRY8 (Prop_CARRY8_SLICEL_S[2]_CO[7])
                                                      0.196     1.277 r  lt/_impl/carry_8/CO[7]
                         net (fo=1, estimated)        0.028     1.305    lt/_impl/co_3[7]
    SLICE_X26Y88         CARRY8 (Prop_CARRY8_SLICEL_CI_CO[7])
                                                      0.023     1.328 r  lt/_impl/carry_17/CO[7]
                         net (fo=1, estimated)        0.028     1.356    lt/_impl/co_7[7]
    SLICE_X26Y89         CARRY8 (Prop_CARRY8_SLICEL_CI_CO[7])
                                                      0.023     1.379 r  lt/_impl/carry_26/CO[7]
                         net (fo=1, estimated)        0.060     1.439    lt/_impl/co_11[7]
    SLICE_X26Y90         CARRY8 (Prop_CARRY8_SLICEL_CI_CO[7])
                                                      0.023     1.462 r  lt/_impl/carry_35/CO[7]
                         net (fo=1, estimated)        0.162     1.624    fsm/out0
    SLICE_X26Y91         LUT6 (Prop_D6LUT_SLICEL_I0_O)
                                                      0.039     1.663 r  fsm/out[0]_i_1/O
                         net (fo=1, routed)           0.058     1.721    comb_reg/out_reg[0]_0
    SLICE_X26Y91         FDRE                                         r  comb_reg/out_reg[0]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=3, unset)            0.024     5.024    comb_reg/clk
    SLICE_X26Y91         FDRE                                         r  comb_reg/out_reg[0]/C
                         clock pessimism              0.000     5.024    
                         clock uncertainty           -0.035     4.989    
    SLICE_X26Y91         FDRE (Setup_DFF_SLICEL_C_D)
                                                      0.027     5.016    comb_reg/out_reg[0]
  -------------------------------------------------------------------
                         required time                          5.016    
                         arrival time                          -1.721    
  -------------------------------------------------------------------
                         slack                                  3.295    




