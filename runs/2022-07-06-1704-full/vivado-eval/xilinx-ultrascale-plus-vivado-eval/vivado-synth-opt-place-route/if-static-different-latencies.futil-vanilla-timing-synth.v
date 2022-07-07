Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:25:29 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//if-static-different-latencies.futil-vanilla-timing-synth.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack:                    inf
  Source:                 fsm/out_reg[0]/C
                            (rising edge-triggered cell FDRE)
  Destination:            i_write_data[30]
                            (output port)
  Path Group:             (none)
  Path Type:              Max at Slow Process Corner
  Data Path Delay:        1.333ns  (logic 0.683ns (51.238%)  route 0.650ns (48.762%))
  Logic Levels:           7  (CARRY8=4 FDRE=1 LUT5=2)

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         FDRE                         0.000     0.000 r  fsm/out_reg[0]/C
                         FDRE (Prop_FDRE_C_Q)         0.093     0.093 f  fsm/out_reg[0]/Q
                         net (fo=76, unplaced)        0.185     0.278    fsm/fsm_out[0]
                         LUT5 (Prop_LUT5_I2_O)        0.139     0.417 r  fsm/i_write_data[7]_INST_0_i_2/O
                         net (fo=1, unplaced)         0.287     0.704    fsm/i_write_data[7]_INST_0_i_2_n_0
                         CARRY8 (Prop_CARRY8_DI[0]_CO[7])
                                                      0.177     0.881 r  fsm/i_write_data[7]_INST_0_i_1/CO[7]
                         net (fo=1, unplaced)         0.007     0.888    fsm/i_write_data[7]_INST_0_i_1_n_0
                         CARRY8 (Prop_CARRY8_CI_CO[7])
                                                      0.030     0.918 r  fsm/i_write_data[15]_INST_0_i_1/CO[7]
                         net (fo=1, unplaced)         0.007     0.925    fsm/i_write_data[15]_INST_0_i_1_n_0
                         CARRY8 (Prop_CARRY8_CI_CO[7])
                                                      0.030     0.955 r  fsm/i_write_data[23]_INST_0_i_1/CO[7]
                         net (fo=1, unplaced)         0.007     0.962    fsm/i_write_data[23]_INST_0_i_1_n_0
                         CARRY8 (Prop_CARRY8_CI_O[6])
                                                      0.129     1.091 r  fsm/i_write_data[31]_INST_0_i_1/O[6]
                         net (fo=1, unplaced)         0.157     1.248    fsm/add_out[30]
                         LUT5 (Prop_LUT5_I4_O)        0.085     1.333 r  fsm/i_write_data[30]_INST_0/O
                         net (fo=0)                   0.000     1.333    i_write_data[30]
                                                                      r  i_write_data[30] (OUT)
  -------------------------------------------------------------------    -------------------




