Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 02:36:34 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//std-fp-sdiv.futil-vanilla-timing-route.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack (MET) :             1.406ns  (required time - arrival time)
  Source:                 fsm/out_reg[2]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            div/comp/out_remainder_reg[13]/CE
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        3.504ns  (logic 0.972ns (27.740%)  route 2.532ns (72.260%))
  Logic Levels:           8  (CARRY8=4 LUT4=3 LUT6=1)
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
                         net (fo=244, unset)          0.037     0.037    fsm/clk
    SLICE_X29Y81         FDRE                                         r  fsm/out_reg[2]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X29Y81         FDRE (Prop_CFF2_SLICEM_C_Q)
                                                      0.094     0.131 r  fsm/out_reg[2]/Q
                         net (fo=88, routed)          0.703     0.834    fsm/fsm_out[2]
    SLICE_X21Y77         LUT6 (Prop_H6LUT_SLICEL_I3_O)
                                                      0.064     0.898 r  fsm/right_save[8]_i_11/O
                         net (fo=1, routed)           0.268     1.166    fsm/right_save[8]_i_11_n_0
    SLICE_X21Y78         CARRY8 (Prop_CARRY8_SLICEL_S[0]_CO[7])
                                                      0.238     1.404 r  fsm/right_save_reg[8]_i_2/CO[7]
                         net (fo=1, routed)           0.028     1.432    fsm/right_save_reg[8]_i_2_n_0
    SLICE_X21Y79         CARRY8 (Prop_CARRY8_SLICEL_CI_CO[7])
                                                      0.023     1.455 r  fsm/right_save_reg[16]_i_2/CO[7]
                         net (fo=1, routed)           0.028     1.483    fsm/right_save_reg[16]_i_2_n_0
    SLICE_X21Y80         CARRY8 (Prop_CARRY8_SLICEL_CI_O[0])
                                                      0.072     1.555 f  fsm/right_save_reg[24]_i_2/O[0]
                         net (fo=5, routed)           0.275     1.830    comb_reg1/right_abs0[16]
    SLICE_X24Y81         LUT4 (Prop_D5LUT_SLICEM_I0_O)
                                                      0.120     1.950 f  comb_reg1/right_save[17]_i_1/O
                         net (fo=3, routed)           0.174     2.124    div/comp/D[17]
    SLICE_X24Y82         LUT4 (Prop_F6LUT_SLICEM_I1_O)
                                                      0.148     2.272 r  div/comp/i__carry__0_i_8/O
                         net (fo=1, routed)           0.257     2.529    div/comp/i__carry__0_i_8_n_0
    SLICE_X23Y82         CARRY8 (Prop_CARRY8_SLICEL_DI[0]_CO[7])
                                                      0.174     2.703 r  div/comp/out_remainder0_inferred__0/i__carry__0/CO[7]
                         net (fo=1, routed)           0.355     3.058    div/comp/out_remainder0_inferred__0/i__carry__0_n_0
    SLICE_X28Y79         LUT4 (Prop_E6LUT_SLICEM_I1_O)
                                                      0.039     3.097 r  div/comp/out_remainder[31]_i_1/O
                         net (fo=32, routed)          0.444     3.541    div/comp/out_remainder[31]_i_1_n_0
    SLICE_X27Y76         FDRE                                         r  div/comp/out_remainder_reg[13]/CE
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=244, unset)          0.025     5.025    div/comp/clk
    SLICE_X27Y76         FDRE                                         r  div/comp/out_remainder_reg[13]/C
                         clock pessimism              0.000     5.025    
                         clock uncertainty           -0.035     4.990    
    SLICE_X27Y76         FDRE (Setup_HFF_SLICEL_C_CE)
                                                     -0.043     4.947    div/comp/out_remainder_reg[13]
  -------------------------------------------------------------------
                         required time                          4.947    
                         arrival time                          -3.541    
  -------------------------------------------------------------------
                         slack                                  1.406    




