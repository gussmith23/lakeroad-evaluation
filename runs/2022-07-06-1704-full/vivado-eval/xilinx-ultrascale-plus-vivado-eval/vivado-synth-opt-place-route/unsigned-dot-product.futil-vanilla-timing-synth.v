Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 02:24:56 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//unsigned-dot-product.futil-vanilla-timing-synth.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack:                    inf
  Source:                 fsm/out_reg[0]/C
                            (rising edge-triggered cell FDRE)
  Destination:            fsm/out_reg[0]/CE
  Path Group:             (none)
  Path Type:              Max at Slow Process Corner
  Data Path Delay:        0.754ns  (logic 0.173ns (22.944%)  route 0.581ns (77.056%))
  Logic Levels:           3  (FDRE=1 LUT4=1 LUT5=1)

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         FDRE                         0.000     0.000 r  fsm/out_reg[0]/C
                         FDRE (Prop_FDRE_C_Q)         0.093     0.093 r  fsm/out_reg[0]/Q
                         net (fo=18, unplaced)        0.205     0.298    counter/Q[0]
                         LUT4 (Prop_LUT4_I3_O)        0.040     0.338 r  counter/out[2]_i_4/O
                         net (fo=1, unplaced)         0.210     0.548    fsm/out_reg[0]_3
                         LUT5 (Prop_LUT5_I4_O)        0.040     0.588 r  fsm/out[2]_i_1__0/O
                         net (fo=3, unplaced)         0.166     0.754    fsm/fsm_write_en
                         FDRE                                         r  fsm/out_reg[0]/CE
  -------------------------------------------------------------------    -------------------




