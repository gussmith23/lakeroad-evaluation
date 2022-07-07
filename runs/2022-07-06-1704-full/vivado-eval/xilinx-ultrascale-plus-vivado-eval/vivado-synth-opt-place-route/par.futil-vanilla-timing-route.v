Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:02:24 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//par.futil-vanilla-timing-route.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Report

Slack:                    inf
  Source:                 a_done
                            (input port)
  Destination:            done
                            (output port)
  Path Group:             (none)
  Path Type:              Max at Slow Process Corner
  Data Path Delay:        0.100ns  (logic 0.100ns (100.000%)  route 0.000ns (0.000%))
  Logic Levels:           1  (LUT3=1)

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                                                      0.000     0.000 r  a_done (IN)
                         net (fo=0)                   0.000     0.000    a_done
    SLICE_X26Y90         LUT3 (Prop_H6LUT_SLICEL_I0_O)
                                                      0.100     0.100 r  done_INST_0/O
                         net (fo=0)                   0.000     0.100    done
                                                                      r  done (OUT)
  -------------------------------------------------------------------    -------------------




