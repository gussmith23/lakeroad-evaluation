Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:20:16 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//seq.futil-vanilla-timing-synth.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack:                    inf
  Source:                 fsm/out_reg[1]/C
                            (rising edge-triggered cell FDRE)
  Destination:            b/out_reg[0]/CE
  Path Group:             (none)
  Path Type:              Max at Slow Process Corner
  Data Path Delay:        0.656ns  (logic 0.264ns (40.244%)  route 0.392ns (59.756%))
  Logic Levels:           2  (FDRE=1 LUT4=1)

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         FDRE                         0.000     0.000 r  fsm/out_reg[1]/C
                         FDRE (Prop_FDRE_C_Q)         0.093     0.093 f  fsm/out_reg[1]/Q
                         net (fo=39, unplaced)        0.172     0.265    fsm/fsm_out[1]
                         LUT4 (Prop_LUT4_I0_O)        0.171     0.436 r  fsm/out[31]_i_1__0/O
                         net (fo=33, unplaced)        0.220     0.656    b/E[0]
                         FDRE                                         r  b/out_reg[0]/CE
  -------------------------------------------------------------------    -------------------




