Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:24:31 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//pow.futil-ultrascale-timing-route.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack (MET) :             2.195ns  (required time - arrival time)
  Source:                 p/mul/comp/out0__0/DSP_A_B_DATA_INST/CLK
                            (rising edge-triggered cell DSP_A_B_DATA clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            p/mul/comp/out_tmp_reg/DSP_OUTPUT_INST/ALU_OUT[0]
                            (rising edge-triggered cell DSP_OUTPUT clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        2.749ns  (logic 2.707ns (98.472%)  route 0.042ns (1.528%))
  Logic Levels:           6  (DSP_ALU=2 DSP_M_DATA=1 DSP_MULTIPLIER=1 DSP_OUTPUT=1 DSP_PREADD_DATA=1)
  Clock Path Skew:        -0.031ns (DCD - SCD + CPR)
    Destination Clock Delay (DCD):    0.044ns = ( 5.044 - 5.000 ) 
    Source Clock Delay      (SCD):    0.075ns
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
                         net (fo=177, unset)          0.075     0.075    p/mul/comp/out0__0/CLK
    DSP48E2_X3Y49        DSP_A_B_DATA                                 r  p/mul/comp/out0__0/DSP_A_B_DATA_INST/CLK
  -------------------------------------------------------------------    -------------------
    DSP48E2_X3Y49        DSP_A_B_DATA (Prop_DSP_A_B_DATA_DSP48E2_CLK_B2_DATA[17])
                                                      0.263     0.338 r  p/mul/comp/out0__0/DSP_A_B_DATA_INST/B2_DATA[17]
                         net (fo=1, routed)           0.000     0.338    p/mul/comp/out0__0/DSP_A_B_DATA.B2_DATA<17>
    DSP48E2_X3Y49        DSP_PREADD_DATA (Prop_DSP_PREADD_DATA_DSP48E2_B2_DATA[17]_B2B1[17])
                                                      0.092     0.430 r  p/mul/comp/out0__0/DSP_PREADD_DATA_INST/B2B1[17]
                         net (fo=1, routed)           0.000     0.430    p/mul/comp/out0__0/DSP_PREADD_DATA.B2B1<17>
    DSP48E2_X3Y49        DSP_MULTIPLIER (Prop_DSP_MULTIPLIER_DSP48E2_B2B1[17]_U[43])
                                                      0.737     1.167 f  p/mul/comp/out0__0/DSP_MULTIPLIER_INST/U[43]
                         net (fo=1, routed)           0.000     1.167    p/mul/comp/out0__0/DSP_MULTIPLIER.U<43>
    DSP48E2_X3Y49        DSP_M_DATA (Prop_DSP_M_DATA_DSP48E2_U[43]_U_DATA[43])
                                                      0.059     1.226 r  p/mul/comp/out0__0/DSP_M_DATA_INST/U_DATA[43]
                         net (fo=1, routed)           0.000     1.226    p/mul/comp/out0__0/DSP_M_DATA.U_DATA<43>
    DSP48E2_X3Y49        DSP_ALU (Prop_DSP_ALU_DSP48E2_U_DATA[43]_ALU_OUT[47])
                                                      0.699     1.925 f  p/mul/comp/out0__0/DSP_ALU_INST/ALU_OUT[47]
                         net (fo=1, routed)           0.000     1.925    p/mul/comp/out0__0/DSP_ALU.ALU_OUT<47>
    DSP48E2_X3Y49        DSP_OUTPUT (Prop_DSP_OUTPUT_DSP48E2_ALU_OUT[47]_PCOUT[47])
                                                      0.159     2.084 r  p/mul/comp/out0__0/DSP_OUTPUT_INST/PCOUT[47]
                         net (fo=1, routed)           0.042     2.126    p/mul/comp/out_tmp_reg/PCIN[47]
    DSP48E2_X3Y50        DSP_ALU (Prop_DSP_ALU_DSP48E2_PCIN[47]_ALU_OUT[0])
                                                      0.698     2.824 r  p/mul/comp/out_tmp_reg/DSP_ALU_INST/ALU_OUT[0]
                         net (fo=1, routed)           0.000     2.824    p/mul/comp/out_tmp_reg/DSP_ALU.ALU_OUT<0>
    DSP48E2_X3Y50        DSP_OUTPUT                                   r  p/mul/comp/out_tmp_reg/DSP_OUTPUT_INST/ALU_OUT[0]
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=177, unset)          0.044     5.044    p/mul/comp/out_tmp_reg/CLK
    DSP48E2_X3Y50        DSP_OUTPUT                                   r  p/mul/comp/out_tmp_reg/DSP_OUTPUT_INST/CLK
                         clock pessimism              0.000     5.044    
                         clock uncertainty           -0.035     5.009    
    DSP48E2_X3Y50        DSP_OUTPUT (Setup_DSP_OUTPUT_DSP48E2_CLK_ALU_OUT[0])
                                                      0.010     5.019    p/mul/comp/out_tmp_reg/DSP_OUTPUT_INST
  -------------------------------------------------------------------
                         required time                          5.019    
                         arrival time                          -2.824    
  -------------------------------------------------------------------
                         slack                                  2.195    




