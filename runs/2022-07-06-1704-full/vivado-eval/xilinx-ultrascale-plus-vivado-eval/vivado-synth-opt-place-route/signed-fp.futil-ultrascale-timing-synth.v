Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 02:50:16 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//signed-fp.futil-ultrascale-timing-synth.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack:                    inf
  Source:                 mem0_read_data[0]
                            (input port)
  Destination:            mem0_write_data[0]
                            (output port)
  Path Group:             (none)
  Path Type:              Max at Slow Process Corner
  Data Path Delay:        0.064ns  (logic 0.064ns (100.000%)  route 0.000ns (0.000%))
  Logic Levels:           1  (LUT2=1)

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                                                      0.000     0.000 r  mem0_read_data[0] (IN)
                         net (fo=0)                   0.000     0.000    mem0_read_data[0]
                         LUT2 (Prop_LUT2_I0_O)        0.064     0.064 r  mem0_write_data[0]_INST_0/O
                         net (fo=0)                   0.000     0.064    mem0_write_data[0]
                                                                      r  mem0_write_data[0] (OUT)
  -------------------------------------------------------------------    -------------------




