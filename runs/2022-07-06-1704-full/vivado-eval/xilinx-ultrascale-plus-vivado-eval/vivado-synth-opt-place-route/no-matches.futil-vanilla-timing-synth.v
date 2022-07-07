Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:11:46 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//no-matches.futil-vanilla-timing-synth.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack:                    inf
  Source:                 fsm/out_reg[1]/C
                            (rising edge-triggered cell FDRE)
  Destination:            tcam/me0/r/out_reg[0]/D
  Path Group:             (none)
  Path Type:              Max at Slow Process Corner
  Data Path Delay:        1.703ns  (logic 0.490ns (28.773%)  route 1.213ns (71.227%))
  Logic Levels:           7  (CARRY8=1 FDRE=1 LUT3=1 LUT5=2 LUT6=2)

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         FDRE                         0.000     0.000 r  fsm/out_reg[1]/C
                         FDRE (Prop_FDRE_C_Q)         0.093     0.093 r  fsm/out_reg[1]/Q
                         net (fo=22, unplaced)        0.157     0.250    fsm/Q[1]
                         LUT3 (Prop_LUT3_I0_O)        0.100     0.350 r  fsm/out[1]_i_2__35/O
                         net (fo=18, unplaced)        0.257     0.607    tcam/fsm32/out_reg[0]_11
                         LUT6 (Prop_LUT6_I1_O)        0.040     0.647 f  tcam/fsm32/out[1]_i_2__31/O
                         net (fo=3, unplaced)         0.216     0.863    tcam/pd39/out_reg[0]_8
                         LUT5 (Prop_LUT5_I4_O)        0.040     0.903 r  tcam/pd39/done_i_2__33/O
                         net (fo=102, unplaced)       0.296     1.199    tcam/p0/out_carry
                         LUT6 (Prop_LUT6_I3_O)        0.040     1.239 r  tcam/p0/out_carry_i_2/O
                         net (fo=1, unplaced)         0.021     1.260    tcam/me0/eq/S[0]
                         CARRY8 (Prop_CARRY8_S[0]_CO[1])
                                                      0.137     1.397 r  tcam/me0/eq/out_carry/CO[1]
                         net (fo=1, unplaced)         0.208     1.605    tcam/me0/r/CO[0]
                         LUT5 (Prop_LUT5_I0_O)        0.040     1.645 r  tcam/me0/r/out[0]_i_1/O
                         net (fo=1, unplaced)         0.058     1.703    tcam/me0/r/out[0]_i_1_n_0
                         FDRE                                         r  tcam/me0/r/out_reg[0]/D
  -------------------------------------------------------------------    -------------------




