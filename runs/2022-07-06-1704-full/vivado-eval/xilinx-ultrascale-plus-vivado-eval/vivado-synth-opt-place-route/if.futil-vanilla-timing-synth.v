Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:30:41 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//if.futil-vanilla-timing-synth.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack:                    inf
  Source:                 comb_reg/out_reg[0]/C
                            (rising edge-triggered cell FDRE)
  Destination:            fsm/out_reg[1]/D
  Path Group:             (none)
  Path Type:              Max at Slow Process Corner
  Data Path Delay:        0.513ns  (logic 0.272ns (53.021%)  route 0.241ns (46.979%))
  Logic Levels:           2  (FDRE=1 LUT6=1)

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         FDRE                         0.000     0.000 r  comb_reg/out_reg[0]/C
                         FDRE (Prop_FDRE_C_Q)         0.093     0.093 f  comb_reg/out_reg[0]/Q
                         net (fo=3, unplaced)         0.183     0.276    comb_reg/comb_reg_out
                         LUT6 (Prop_LUT6_I0_O)        0.179     0.455 r  comb_reg/out[1]_i_2/O
                         net (fo=1, unplaced)         0.058     0.513    fsm/D[1]
                         FDRE                                         r  fsm/out_reg[1]/D
  -------------------------------------------------------------------    -------------------




