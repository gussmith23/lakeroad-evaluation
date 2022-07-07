Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 02:38:02 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//std-fp-sdiv.futil-ultrascale-timing-route.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack (MET) :             1.236ns  (required time - arrival time)
  Source:                 fsm/out_reg[0]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            div/comp/out_remainder_reg[30]/CE
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        3.676ns  (logic 0.999ns (27.176%)  route 2.677ns (72.824%))
  Logic Levels:           8  (CARRY8=4 LUT4=3 LUT6=1)
  Clock Path Skew:        -0.010ns (DCD - SCD + CPR)
    Destination Clock Delay (DCD):    0.026ns = ( 5.026 - 5.000 ) 
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
                         net (fo=244, unset)          0.036     0.036    fsm/clk
    SLICE_X15Y43         FDRE                                         r  fsm/out_reg[0]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X15Y43         FDRE (Prop_FFF_SLICEL_C_Q)
                                                      0.096     0.132 f  fsm/out_reg[0]/Q
                         net (fo=96, routed)          0.577     0.709    fsm/fsm_out[0]
    SLICE_X19Y34         LUT6 (Prop_H6LUT_SLICEM_I2_O)
                                                      0.100     0.809 r  fsm/right_save[8]_i_11/O
                         net (fo=1, routed)           0.338     1.147    fsm/right_save[8]_i_11_n_0
    SLICE_X18Y34         CARRY8 (Prop_CARRY8_SLICEL_S[0]_CO[7])
                                                      0.238     1.385 r  fsm/right_save_reg[8]_i_2/CO[7]
                         net (fo=1, routed)           0.028     1.413    fsm/right_save_reg[8]_i_2_n_0
    SLICE_X18Y35         CARRY8 (Prop_CARRY8_SLICEL_CI_CO[7])
                                                      0.023     1.436 r  fsm/right_save_reg[16]_i_2/CO[7]
                         net (fo=1, routed)           0.028     1.464    fsm/right_save_reg[16]_i_2_n_0
    SLICE_X18Y36         CARRY8 (Prop_CARRY8_SLICEL_CI_O[6])
                                                      0.129     1.593 f  fsm/right_save_reg[24]_i_2/O[6]
                         net (fo=5, routed)           0.429     2.022    comb_reg1/right_abs0[22]
    SLICE_X15Y40         LUT4 (Prop_D5LUT_SLICEL_I0_O)
                                                      0.136     2.158 f  comb_reg1/right_save[23]_i_1/O
                         net (fo=3, routed)           0.208     2.366    div/comp/D[22]
    SLICE_X16Y40         LUT4 (Prop_H6LUT_SLICEM_I1_O)
                                                      0.100     2.466 r  div/comp/i__carry__0_i_5/O
                         net (fo=1, routed)           0.237     2.703    div/comp/i__carry__0_i_5_n_0
    SLICE_X17Y40         CARRY8 (Prop_CARRY8_SLICEL_DI[3]_CO[7])
                                                      0.138     2.841 r  div/comp/out_remainder0_inferred__0/i__carry__0/CO[7]
                         net (fo=1, routed)           0.376     3.217    div/comp/out_remainder0_inferred__0/i__carry__0_n_0
    SLICE_X19Y37         LUT4 (Prop_E6LUT_SLICEM_I1_O)
                                                      0.039     3.256 r  div/comp/out_remainder[31]_i_1/O
                         net (fo=32, routed)          0.456     3.712    div/comp/out_remainder[31]_i_1_n_0
    SLICE_X20Y43         FDRE                                         r  div/comp/out_remainder_reg[30]/CE
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=244, unset)          0.026     5.026    div/comp/clk
    SLICE_X20Y43         FDRE                                         r  div/comp/out_remainder_reg[30]/C
                         clock pessimism              0.000     5.026    
                         clock uncertainty           -0.035     4.991    
    SLICE_X20Y43         FDRE (Setup_DFF_SLICEM_C_CE)
                                                     -0.043     4.948    div/comp/out_remainder_reg[30]
  -------------------------------------------------------------------
                         required time                          4.948    
                         arrival time                          -3.712    
  -------------------------------------------------------------------
                         slack                                  1.236    




