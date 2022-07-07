Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:26:45 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//if-static-different-latencies.futil-ultrascale-timing-synth.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack:                    inf
  Source:                 fsm/out_reg[1]/C
                            (rising edge-triggered cell FDRE)
  Destination:            i_write_data[28]
                            (output port)
  Path Group:             (none)
  Path Type:              Max at Slow Process Corner
  Data Path Delay:        1.650ns  (logic 0.735ns (44.545%)  route 0.915ns (55.455%))
  Logic Levels:           8  (CARRY8=4 FDRE=1 LUT4=1 LUT5=2)

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         FDRE                         0.000     0.000 r  fsm/out_reg[1]/C
                         FDRE (Prop_FDRE_C_Q)         0.093     0.093 r  fsm/out_reg[1]/Q
                         net (fo=77, unplaced)        0.188     0.281    fsm/fsm_out[1]
                         LUT4 (Prop_LUT4_I0_O)        0.171     0.452 r  fsm/i_write_en_INST_0/O
                         net (fo=2, unplaced)         0.210     0.662    add/_impl/A_LUT_0/I1
                         LUT5 (Prop_LUT5_I1_O)        0.085     0.747 r  add/_impl/A_LUT_0/LUT5/O
                         net (fo=1, unplaced)         0.287     1.034    add/_impl/luts_O5_0[0]
                         CARRY8 (Prop_CARRY8_DI[0]_CO[7])
                                                      0.177     1.211 r  add/_impl/carry_8/CO[7]
                         net (fo=1, unplaced)         0.007     1.218    add/_impl/co_3[7]
                         CARRY8 (Prop_CARRY8_CI_CO[7])
                                                      0.030     1.248 r  add/_impl/carry_17/CO[7]
                         net (fo=1, unplaced)         0.007     1.255    add/_impl/co_7[7]
                         CARRY8 (Prop_CARRY8_CI_CO[7])
                                                      0.030     1.285 r  add/_impl/carry_26/CO[7]
                         net (fo=1, unplaced)         0.007     1.292    add/_impl/co_11[7]
                         CARRY8 (Prop_CARRY8_CI_O[4])
                                                      0.109     1.401 r  add/_impl/carry_35/O[4]
                         net (fo=1, unplaced)         0.209     1.610    fsm/out0[28]
                         LUT5 (Prop_LUT5_I4_O)        0.040     1.650 r  fsm/i_write_data[28]_INST_0/O
                         net (fo=0)                   0.000     1.650    i_write_data[28]
                                                                      r  i_write_data[28] (OUT)
  -------------------------------------------------------------------    -------------------




