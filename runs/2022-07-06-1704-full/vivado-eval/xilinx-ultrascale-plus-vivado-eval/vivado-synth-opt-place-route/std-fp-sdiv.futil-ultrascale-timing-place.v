Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 02:37:49 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//std-fp-sdiv.futil-ultrascale-timing-place.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack (MET) :             1.392ns  (required time - arrival time)
  Source:                 fsm/out_reg[0]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            div/comp/out_remainder_reg[24]/CE
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        3.519ns  (logic 0.901ns (25.604%)  route 2.618ns (74.396%))
  Logic Levels:           8  (CARRY8=4 LUT4=3 LUT6=1)
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
                         net (fo=244, unset)          0.036     0.036    fsm/clk
    SLICE_X15Y43         FDRE                                         r  fsm/out_reg[0]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X15Y43         FDRE (Prop_FFF_SLICEL_C_Q)
                                                      0.096     0.132 f  fsm/out_reg[0]/Q
                         net (fo=96, estimated)       0.544     0.676    fsm/fsm_out[0]
    SLICE_X19Y34         LUT6 (Prop_H6LUT_SLICEM_I2_O)
                                                      0.117     0.793 r  fsm/right_save[8]_i_11/O
                         net (fo=1, estimated)        0.258     1.051    fsm/right_save[8]_i_11_n_0
    SLICE_X18Y34         CARRY8 (Prop_CARRY8_SLICEL_S[0]_CO[7])
                                                      0.238     1.289 r  fsm/right_save_reg[8]_i_2/CO[7]
                         net (fo=1, estimated)        0.028     1.317    fsm/right_save_reg[8]_i_2_n_0
    SLICE_X18Y35         CARRY8 (Prop_CARRY8_SLICEL_CI_CO[7])
                                                      0.023     1.340 r  fsm/right_save_reg[16]_i_2/CO[7]
                         net (fo=1, estimated)        0.028     1.368    fsm/right_save_reg[16]_i_2_n_0
    SLICE_X18Y36         CARRY8 (Prop_CARRY8_SLICEL_CI_O[2])
                                                      0.086     1.454 f  fsm/right_save_reg[24]_i_2/O[2]
                         net (fo=5, estimated)        0.419     1.873    comb_reg1/right_abs0[18]
    SLICE_X15Y40         LUT4 (Prop_B5LUT_SLICEL_I0_O)
                                                      0.089     1.962 f  comb_reg1/right_save[19]_i_1/O
                         net (fo=3, estimated)        0.272     2.234    div/comp/D[19]
    SLICE_X15Y40         LUT4 (Prop_G6LUT_SLICEL_I1_O)
                                                      0.063     2.297 r  div/comp/i__carry__0_i_7/O
                         net (fo=1, estimated)        0.245     2.542    div/comp/i__carry__0_i_7_n_0
    SLICE_X17Y40         CARRY8 (Prop_CARRY8_SLICEL_DI[1]_CO[7])
                                                      0.150     2.692 r  div/comp/out_remainder0_inferred__0/i__carry__0/CO[7]
                         net (fo=1, estimated)        0.380     3.072    div/comp/out_remainder0_inferred__0/i__carry__0_n_0
    SLICE_X19Y37         LUT4 (Prop_E6LUT_SLICEM_I1_O)
                                                      0.039     3.111 r  div/comp/out_remainder[31]_i_1/O
                         net (fo=32, estimated)       0.444     3.555    div/comp/out_remainder[31]_i_1_n_0
    SLICE_X22Y41         FDRE                                         r  div/comp/out_remainder_reg[24]/CE
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=244, unset)          0.025     5.025    div/comp/clk
    SLICE_X22Y41         FDRE                                         r  div/comp/out_remainder_reg[24]/C
                         clock pessimism              0.000     5.025    
                         clock uncertainty           -0.035     4.990    
    SLICE_X22Y41         FDRE (Setup_HFF_SLICEL_C_CE)
                                                     -0.043     4.947    div/comp/out_remainder_reg[24]
  -------------------------------------------------------------------
                         required time                          4.947    
                         arrival time                          -3.555    
  -------------------------------------------------------------------
                         slack                                  1.392    




