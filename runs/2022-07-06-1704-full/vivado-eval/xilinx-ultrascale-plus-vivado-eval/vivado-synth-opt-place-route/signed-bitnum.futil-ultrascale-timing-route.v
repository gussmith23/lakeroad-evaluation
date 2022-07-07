Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 02:48:17 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//signed-bitnum.futil-ultrascale-timing-route.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack:                    inf
  Source:                 mem0_read_data[21]
                            (input port)
  Destination:            mem0_write_data[21]
                            (output port)
  Path Group:             (none)
  Path Type:              Max at Slow Process Corner
  Data Path Delay:        0.180ns  (logic 0.145ns (80.556%)  route 0.035ns (19.444%))
  Logic Levels:           1  (LUT2=1)

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                                                      0.000     0.000 r  mem0_read_data[21] (IN)
                         net (fo=0)                   0.000     0.000    mem0_read_data[21]
    SLICE_X26Y87         LUT2 (Prop_F5LUT_SLICEL_I1_O)
                                                      0.145     0.145 r  mem0_write_data[21]_INST_0/O
                         net (fo=0)                   0.035     0.180    mem0_write_data[21]
                                                                      r  mem0_write_data[21] (OUT)
  -------------------------------------------------------------------    -------------------




