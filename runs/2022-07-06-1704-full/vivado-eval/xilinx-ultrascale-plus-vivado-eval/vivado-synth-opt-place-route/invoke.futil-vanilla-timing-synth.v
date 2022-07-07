Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:28:03 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//invoke.futil-vanilla-timing-synth.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack:                    inf
  Source:                 exp0/mul/comp/out0__0/DSP_A_B_DATA_INST/CLK
                            (rising edge-triggered cell DSP_A_B_DATA)
  Destination:            exp0/mul/comp/out_tmp_reg[7]__0/D
  Path Group:             (none)
  Path Type:              Max at Slow Process Corner
  Data Path Delay:        2.324ns  (logic 1.991ns (85.671%)  route 0.333ns (14.329%))
  Logic Levels:           6  (DSP_A_B_DATA=1 DSP_ALU=1 DSP_M_DATA=1 DSP_MULTIPLIER=1 DSP_OUTPUT=1 DSP_PREADD_DATA=1)

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         DSP_A_B_DATA                 0.000     0.000 r  exp0/mul/comp/out0__0/DSP_A_B_DATA_INST/CLK
                         DSP_A_B_DATA (Prop_DSP_A_B_DATA_CLK_B2_DATA[7])
                                                      0.263     0.263 r  exp0/mul/comp/out0__0/DSP_A_B_DATA_INST/B2_DATA[7]
                         net (fo=1, unplaced)         0.000     0.263    exp0/mul/comp/out0__0/DSP_A_B_DATA.B2_DATA<7>
                         DSP_PREADD_DATA (Prop_DSP_PREADD_DATA_B2_DATA[7]_B2B1[7])
                                                      0.092     0.355 r  exp0/mul/comp/out0__0/DSP_PREADD_DATA_INST/B2B1[7]
                         net (fo=1, unplaced)         0.000     0.355    exp0/mul/comp/out0__0/DSP_PREADD_DATA.B2B1<7>
                         DSP_MULTIPLIER (Prop_DSP_MULTIPLIER_B2B1[7]_U[7])
                                                      0.737     1.092 f  exp0/mul/comp/out0__0/DSP_MULTIPLIER_INST/U[7]
                         net (fo=1, unplaced)         0.000     1.092    exp0/mul/comp/out0__0/DSP_MULTIPLIER.U<7>
                         DSP_M_DATA (Prop_DSP_M_DATA_U[7]_U_DATA[7])
                                                      0.059     1.151 r  exp0/mul/comp/out0__0/DSP_M_DATA_INST/U_DATA[7]
                         net (fo=1, unplaced)         0.000     1.151    exp0/mul/comp/out0__0/DSP_M_DATA.U_DATA<7>
                         DSP_ALU (Prop_DSP_ALU_U_DATA[7]_ALU_OUT[7])
                                                      0.699     1.850 f  exp0/mul/comp/out0__0/DSP_ALU_INST/ALU_OUT[7]
                         net (fo=1, unplaced)         0.000     1.850    exp0/mul/comp/out0__0/DSP_ALU.ALU_OUT<7>
                         DSP_OUTPUT (Prop_DSP_OUTPUT_ALU_OUT[7]_P[7])
                                                      0.141     1.991 r  exp0/mul/comp/out0__0/DSP_OUTPUT_INST/P[7]
                         net (fo=1, unplaced)         0.333     2.324    exp0/mul/comp/out0__0_n_98
                         FDRE                                         r  exp0/mul/comp/out_tmp_reg[7]__0/D
  -------------------------------------------------------------------    -------------------




