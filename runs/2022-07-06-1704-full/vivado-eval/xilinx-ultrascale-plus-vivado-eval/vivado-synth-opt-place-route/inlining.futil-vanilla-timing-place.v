Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 02:28:15 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//inlining.futil-vanilla-timing-place.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack (VIOLATED) :        -0.141ns  (required time - arrival time)
  Source:                 fsm2/out_reg[0]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            mul_out0/out_reg[31]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        5.124ns  (logic 3.651ns (71.253%)  route 1.473ns (28.747%))
  Logic Levels:           15  (CARRY8=2 DSP_A_B_DATA=1 DSP_ALU=2 DSP_M_DATA=1 DSP_MULTIPLIER=1 DSP_OUTPUT=2 DSP_PREADD_DATA=1 LUT2=1 LUT3=1 LUT4=1 LUT6=2)
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
                         net (fo=569, unset)          0.035     0.035    fsm2/clk
    SLICE_X25Y48         FDRE                                         r  fsm2/out_reg[0]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X25Y48         FDRE (Prop_DFF_SLICEL_C_Q)
                                                      0.096     0.131 f  fsm2/out_reg[0]/Q
                         net (fo=19, estimated)       0.169     0.300    fsm2/fsm2_out[0]
    SLICE_X25Y49         LUT6 (Prop_C6LUT_SLICEL_I0_O)
                                                      0.174     0.474 f  fsm2/out[1]_i_3/O
                         net (fo=7, estimated)        0.130     0.604    fsm1/out_reg[0]_4
    SLICE_X26Y48         LUT4 (Prop_H6LUT_SLICEL_I3_O)
                                                      0.040     0.644 r  fsm1/out[31]_i_3/O
                         net (fo=9, estimated)        0.140     0.784    fsm2/out_reg[31]
    SLICE_X26Y46         LUT6 (Prop_F6LUT_SLICEL_I5_O)
                                                      0.039     0.823 f  fsm2/out_i_35/O
                         net (fo=127, estimated)      0.422     1.245    left_1_1/out__0
    SLICE_X26Y35         LUT2 (Prop_C6LUT_SLICEL_I1_O)
                                                      0.038     1.283 f  left_1_1/out_i_17/O
                         net (fo=2, estimated)        0.186     1.469    mult00/out/B[0]
    DSP48E2_X2Y14        DSP_A_B_DATA (Prop_DSP_A_B_DATA_DSP48E2_B[0]_B2_DATA[0])
                                                      0.195     1.664 r  mult00/out/DSP_A_B_DATA_INST/B2_DATA[0]
                         net (fo=1, routed)           0.000     1.664    mult00/out/DSP_A_B_DATA.B2_DATA<0>
    DSP48E2_X2Y14        DSP_PREADD_DATA (Prop_DSP_PREADD_DATA_DSP48E2_B2_DATA[0]_B2B1[0])
                                                      0.092     1.756 r  mult00/out/DSP_PREADD_DATA_INST/B2B1[0]
                         net (fo=1, routed)           0.000     1.756    mult00/out/DSP_PREADD_DATA.B2B1<0>
    DSP48E2_X2Y14        DSP_MULTIPLIER (Prop_DSP_MULTIPLIER_DSP48E2_B2B1[0]_U[31])
                                                      0.737     2.493 f  mult00/out/DSP_MULTIPLIER_INST/U[31]
                         net (fo=1, routed)           0.000     2.493    mult00/out/DSP_MULTIPLIER.U<31>
    DSP48E2_X2Y14        DSP_M_DATA (Prop_DSP_M_DATA_DSP48E2_U[31]_U_DATA[31])
                                                      0.059     2.552 r  mult00/out/DSP_M_DATA_INST/U_DATA[31]
                         net (fo=1, routed)           0.000     2.552    mult00/out/DSP_M_DATA.U_DATA<31>
    DSP48E2_X2Y14        DSP_ALU (Prop_DSP_ALU_DSP48E2_U_DATA[31]_ALU_OUT[47])
                                                      0.699     3.251 f  mult00/out/DSP_ALU_INST/ALU_OUT[47]
                         net (fo=1, routed)           0.000     3.251    mult00/out/DSP_ALU.ALU_OUT<47>
    DSP48E2_X2Y14        DSP_OUTPUT (Prop_DSP_OUTPUT_DSP48E2_ALU_OUT[47]_PCOUT[47])
                                                      0.159     3.410 r  mult00/out/DSP_OUTPUT_INST/PCOUT[47]
                         net (fo=1, estimated)        0.016     3.426    mult00/out__0/PCIN[47]
    DSP48E2_X2Y15        DSP_ALU (Prop_DSP_ALU_DSP48E2_PCIN[47]_ALU_OUT[0])
                                                      0.698     4.124 f  mult00/out__0/DSP_ALU_INST/ALU_OUT[0]
                         net (fo=1, routed)           0.000     4.124    mult00/out__0/DSP_ALU.ALU_OUT<0>
    DSP48E2_X2Y15        DSP_OUTPUT (Prop_DSP_OUTPUT_DSP48E2_ALU_OUT[0]_P[0])
                                                      0.141     4.265 r  mult00/out__0/DSP_OUTPUT_INST/P[0]
                         net (fo=1, estimated)        0.333     4.598    mult00/out__0_n_105
    SLICE_X28Y39         LUT3 (Prop_B6LUT_SLICEM_I2_O)
                                                      0.100     4.698 r  mult00/out[23]_i_15__0/O
                         net (fo=1, routed)           0.018     4.716    mult00/out[23]_i_15__0_n_0
    SLICE_X28Y39         CARRY8 (Prop_CARRY8_SLICEM_S[1]_CO[7])
                                                      0.238     4.954 r  mult00/out_reg[23]_i_1__0/CO[7]
                         net (fo=1, estimated)        0.028     4.982    mult00/out_reg[23]_i_1__0_n_0
    SLICE_X28Y40         CARRY8 (Prop_CARRY8_SLICEM_CI_O[7])
                                                      0.146     5.128 r  mult00/out_reg[31]_i_2__0/O[7]
                         net (fo=1, routed)           0.031     5.159    mul_out0/D[31]
    SLICE_X28Y40         FDRE                                         r  mul_out0/out_reg[31]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=569, unset)          0.026     5.026    mul_out0/clk
    SLICE_X28Y40         FDRE                                         r  mul_out0/out_reg[31]/C
                         clock pessimism              0.000     5.026    
                         clock uncertainty           -0.035     4.991    
    SLICE_X28Y40         FDRE (Setup_HFF_SLICEM_C_D)
                                                      0.027     5.018    mul_out0/out_reg[31]
  -------------------------------------------------------------------
                         required time                          5.018    
                         arrival time                          -5.159    
  -------------------------------------------------------------------
                         slack                                 -0.141    




