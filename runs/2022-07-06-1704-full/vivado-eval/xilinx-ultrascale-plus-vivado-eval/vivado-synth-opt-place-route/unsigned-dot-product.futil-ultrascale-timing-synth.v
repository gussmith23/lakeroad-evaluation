Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 02:26:13 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//unsigned-dot-product.futil-ultrascale-timing-synth.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack:                    inf
  Source:                 fsm/out_reg[1]/C
                            (rising edge-triggered cell FDRE)
  Destination:            comb_reg/out_reg[0]/D
  Path Group:             (none)
  Path Type:              Max at Slow Process Corner
  Data Path Delay:        1.286ns  (logic 0.545ns (42.379%)  route 0.741ns (57.621%))
  Logic Levels:           5  (CARRY8=1 FDRE=1 LUT5=2 LUT6=1)

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         FDRE                         0.000     0.000 r  fsm/out_reg[1]/C
                         FDRE (Prop_FDRE_C_Q)         0.093     0.093 r  fsm/out_reg[1]/Q
                         net (fo=19, unplaced)        0.162     0.255    fsm/Q[1]
                         LUT5 (Prop_LUT5_I0_O)        0.150     0.405 f  fsm/A_LUT_0_i_1/O
                         net (fo=2, unplaced)         0.210     0.615    lt0/_impl/A_LUT_0/I0
                         LUT5 (Prop_LUT5_I0_O)        0.085     0.700 r  lt0/_impl/A_LUT_0/LUT5/O
                         net (fo=1, unplaced)         0.287     0.987    lt0/_impl/luts_O5_0[0]
                         CARRY8 (Prop_CARRY8_DI[0]_CO[7])
                                                      0.177     1.164 r  lt0/_impl/carry_8/CO[7]
                         net (fo=1, unplaced)         0.024     1.188    fsm/out0
                         LUT6 (Prop_LUT6_I0_O)        0.040     1.228 r  fsm/out[0]_i_1__1/O
                         net (fo=1, unplaced)         0.058     1.286    comb_reg/out_reg[0]_0
                         FDRE                                         r  comb_reg/out_reg[0]/D
  -------------------------------------------------------------------    -------------------




