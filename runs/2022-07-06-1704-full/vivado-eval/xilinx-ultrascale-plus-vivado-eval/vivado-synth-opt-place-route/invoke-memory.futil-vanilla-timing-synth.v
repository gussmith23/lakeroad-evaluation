Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:17:44 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//invoke-memory.futil-vanilla-timing-synth.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack:                    inf
  Source:                 copy0/fsm/out_reg[1]/C
                            (rising edge-triggered cell FDRE)
  Destination:            copy0/comb_reg/out_reg[0]/D
  Path Group:             (none)
  Path Type:              Max at Slow Process Corner
  Data Path Delay:        0.732ns  (logic 0.283ns (38.661%)  route 0.449ns (61.339%))
  Logic Levels:           3  (FDRE=1 LUT5=2)

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         FDRE                         0.000     0.000 r  copy0/fsm/out_reg[1]/C
                         FDRE (Prop_FDRE_C_Q)         0.093     0.093 r  copy0/fsm/out_reg[1]/Q
                         net (fo=44, unplaced)        0.181     0.274    copy0/fsm/fsm_out[1]
                         LUT5 (Prop_LUT5_I0_O)        0.150     0.424 r  copy0/fsm/done_i_1/O
                         net (fo=2, unplaced)         0.210     0.634    copy0/N/cond0_go_in
                         LUT5 (Prop_LUT5_I3_O)        0.040     0.674 r  copy0/N/out[0]_i_1__1/O
                         net (fo=1, unplaced)         0.058     0.732    copy0/comb_reg/out_reg[0]_0
                         FDRE                                         r  copy0/comb_reg/out_reg[0]/D
  -------------------------------------------------------------------    -------------------




