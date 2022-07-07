Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 02:30:14 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//inlining.futil-ultrascale-timing-route.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack (VIOLATED) :        -0.089ns  (required time - arrival time)
  Source:                 pd21/out_reg[0]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            mul_out1/out_reg[31]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        5.072ns  (logic 3.651ns (71.983%)  route 1.421ns (28.017%))
  Logic Levels:           14  (CARRY8=2 DSP_A_B_DATA=1 DSP_ALU=2 DSP_M_DATA=1 DSP_MULTIPLIER=1 DSP_OUTPUT=2 DSP_PREADD_DATA=1 LUT2=1 LUT3=1 LUT6=2)
  Clock Path Skew:        -0.009ns (DCD - SCD + CPR)
    Destination Clock Delay (DCD):    0.026ns = ( 5.026 - 5.000 ) 
    Source Clock Delay      (SCD):    0.035ns
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
                         net (fo=569, unset)          0.035     0.035    pd21/clk
    SLICE_X26Y82         FDRE                                         r  pd21/out_reg[0]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X26Y82         FDRE (Prop_AFF_SLICEL_C_Q)
                                                      0.096     0.131 r  pd21/out_reg[0]/Q
                         net (fo=5, routed)           0.297     0.428    fsm2/pd21_out
    SLICE_X25Y80         LUT6 (Prop_C6LUT_SLICEL_I0_O)
                                                      0.174     0.602 f  fsm2/out[31]_i_3/O
                         net (fo=1, routed)           0.111     0.713    mul_out1/out_reg[31]_0
    SLICE_X25Y82         LUT6 (Prop_A6LUT_SLICEL_I1_O)
                                                      0.115     0.828 f  mul_out1/out[31]_i_1__4/O
                         net (fo=127, routed)         0.296     1.124    left_0_1/do_mul1_go_in
    SLICE_X25Y88         LUT2 (Prop_D6LUT_SLICEL_I1_O)
                                                      0.039     1.163 f  left_0_1/out_i_8__7/O
                         net (fo=2, routed)           0.227     1.390    mult01/out__0/B[9]
    DSP48E2_X2Y35        DSP_A_B_DATA (Prop_DSP_A_B_DATA_DSP48E2_B[9]_B2_DATA[9])
                                                      0.195     1.585 r  mult01/out__0/DSP_A_B_DATA_INST/B2_DATA[9]
                         net (fo=1, routed)           0.000     1.585    mult01/out__0/DSP_A_B_DATA.B2_DATA<9>
    DSP48E2_X2Y35        DSP_PREADD_DATA (Prop_DSP_PREADD_DATA_DSP48E2_B2_DATA[9]_B2B1[9])
                                                      0.092     1.677 r  mult01/out__0/DSP_PREADD_DATA_INST/B2B1[9]
                         net (fo=1, routed)           0.000     1.677    mult01/out__0/DSP_PREADD_DATA.B2B1<9>
    DSP48E2_X2Y35        DSP_MULTIPLIER (Prop_DSP_MULTIPLIER_DSP48E2_B2B1[9]_U[40])
                                                      0.737     2.414 f  mult01/out__0/DSP_MULTIPLIER_INST/U[40]
                         net (fo=1, routed)           0.000     2.414    mult01/out__0/DSP_MULTIPLIER.U<40>
    DSP48E2_X2Y35        DSP_M_DATA (Prop_DSP_M_DATA_DSP48E2_U[40]_U_DATA[40])
                                                      0.059     2.473 r  mult01/out__0/DSP_M_DATA_INST/U_DATA[40]
                         net (fo=1, routed)           0.000     2.473    mult01/out__0/DSP_M_DATA.U_DATA<40>
    DSP48E2_X2Y35        DSP_ALU (Prop_DSP_ALU_DSP48E2_U_DATA[40]_ALU_OUT[47])
                                                      0.699     3.172 f  mult01/out__0/DSP_ALU_INST/ALU_OUT[47]
                         net (fo=1, routed)           0.000     3.172    mult01/out__0/DSP_ALU.ALU_OUT<47>
    DSP48E2_X2Y35        DSP_OUTPUT (Prop_DSP_OUTPUT_DSP48E2_ALU_OUT[47]_PCOUT[47])
                                                      0.159     3.331 r  mult01/out__0/DSP_OUTPUT_INST/PCOUT[47]
                         net (fo=1, routed)           0.080     3.411    mult01/out__0__0/PCIN[47]
    DSP48E2_X2Y36        DSP_ALU (Prop_DSP_ALU_DSP48E2_PCIN[47]_ALU_OUT[0])
                                                      0.698     4.109 f  mult01/out__0__0/DSP_ALU_INST/ALU_OUT[0]
                         net (fo=1, routed)           0.000     4.109    mult01/out__0__0/DSP_ALU.ALU_OUT<0>
    DSP48E2_X2Y36        DSP_OUTPUT (Prop_DSP_OUTPUT_DSP48E2_ALU_OUT[0]_P[0])
                                                      0.141     4.250 r  mult01/out__0__0/DSP_OUTPUT_INST/P[0]
                         net (fo=1, routed)           0.301     4.551    mult01/out__0__0_n_105
    SLICE_X29Y89         LUT3 (Prop_B6LUT_SLICEM_I1_O)
                                                      0.063     4.614 r  mult01/out[23]_i_15__1/O
                         net (fo=1, routed)           0.018     4.632    mult01/out[23]_i_15__1_n_0
    SLICE_X29Y89         CARRY8 (Prop_CARRY8_SLICEM_S[1]_CO[7])
                                                      0.238     4.870 r  mult01/out_reg[23]_i_1__1/CO[7]
                         net (fo=1, routed)           0.060     4.930    mult01/out_reg[23]_i_1__1_n_0
    SLICE_X29Y90         CARRY8 (Prop_CARRY8_SLICEM_CI_O[7])
                                                      0.146     5.076 r  mult01/out_reg[31]_i_2__1/O[7]
                         net (fo=1, routed)           0.031     5.107    mul_out1/out[15]
    SLICE_X29Y90         FDRE                                         r  mul_out1/out_reg[31]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=569, unset)          0.026     5.026    mul_out1/clk
    SLICE_X29Y90         FDRE                                         r  mul_out1/out_reg[31]/C
                         clock pessimism              0.000     5.026    
                         clock uncertainty           -0.035     4.991    
    SLICE_X29Y90         FDRE (Setup_HFF_SLICEM_C_D)
                                                      0.027     5.018    mul_out1/out_reg[31]
  -------------------------------------------------------------------
                         required time                          5.018    
                         arrival time                          -5.107    
  -------------------------------------------------------------------
                         slack                                 -0.089    




