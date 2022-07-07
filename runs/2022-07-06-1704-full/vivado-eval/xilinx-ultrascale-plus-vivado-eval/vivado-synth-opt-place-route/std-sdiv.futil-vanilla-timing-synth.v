Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 02:54:11 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//std-sdiv.futil-vanilla-timing-synth.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack:                    inf
  Source:                 div/comp/out_remainder_reg[8]/C
                            (rising edge-triggered cell FDRE)
  Destination:            out_rem_write_data[29]
                            (output port)
  Path Group:             (none)
  Path Type:              Max at Slow Process Corner
  Data Path Delay:        1.889ns  (logic 0.858ns (45.421%)  route 1.031ns (54.579%))
  Logic Levels:           10  (CARRY8=4 FDRE=1 LUT3=1 LUT4=1 LUT5=1 LUT6=2)

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         FDRE                         0.000     0.000 r  div/comp/out_remainder_reg[8]/C
                         FDRE (Prop_FDRE_C_Q)         0.093     0.093 f  div/comp/out_remainder_reg[8]/Q
                         net (fo=4, unplaced)         0.120     0.213    div/comp/out_remainder[8]
                         LUT4 (Prop_LUT4_I0_O)        0.116     0.329 f  div/comp/out_rem_write_data[31]_INST_0_i_14/O
                         net (fo=1, unplaced)         0.210     0.539    div/comp/out_rem_write_data[31]_INST_0_i_14_n_0
                         LUT5 (Prop_LUT5_I4_O)        0.040     0.579 r  div/comp/out_rem_write_data[31]_INST_0_i_3/O
                         net (fo=1, unplaced)         0.161     0.740    div/comp/out_rem_write_data[31]_INST_0_i_3_n_0
                         LUT6 (Prop_LUT6_I2_O)        0.116     0.856 r  div/comp/out_rem_write_data[31]_INST_0_i_1/O
                         net (fo=64, unplaced)        0.285     1.141    div/comp/out_rem_write_data[31]_INST_0_i_1_n_0
                         LUT3 (Prop_LUT3_I1_O)        0.039     1.180 r  div/comp/out_rem_write_data[8]_INST_0_i_9/O
                         net (fo=1, unplaced)         0.025     1.205    div/comp/out_rem_write_data[8]_INST_0_i_9_n_0
                         CARRY8 (Prop_CARRY8_S[1]_CO[7])
                                                      0.245     1.450 r  div/comp/out_rem_write_data[8]_INST_0_i_1/CO[7]
                         net (fo=1, unplaced)         0.007     1.457    div/comp/out_rem_write_data[8]_INST_0_i_1_n_0
                         CARRY8 (Prop_CARRY8_CI_CO[7])
                                                      0.030     1.487 r  div/comp/out_rem_write_data[16]_INST_0_i_1/CO[7]
                         net (fo=1, unplaced)         0.007     1.494    div/comp/out_rem_write_data[16]_INST_0_i_1_n_0
                         CARRY8 (Prop_CARRY8_CI_CO[7])
                                                      0.030     1.524 r  div/comp/out_rem_write_data[24]_INST_0_i_1/CO[7]
                         net (fo=1, unplaced)         0.007     1.531    div/comp/out_rem_write_data[24]_INST_0_i_1_n_0
                         CARRY8 (Prop_CARRY8_CI_O[4])
                                                      0.109     1.640 r  div/comp/out_rem_write_data[31]_INST_0_i_2/O[4]
                         net (fo=1, unplaced)         0.209     1.849    div/comp/out_remainder0[29]
                         LUT6 (Prop_LUT6_I4_O)        0.040     1.889 r  div/comp/out_rem_write_data[29]_INST_0/O
                         net (fo=0)                   0.000     1.889    out_rem_write_data[29]
                                                                      r  out_rem_write_data[29] (OUT)
  -------------------------------------------------------------------    -------------------




