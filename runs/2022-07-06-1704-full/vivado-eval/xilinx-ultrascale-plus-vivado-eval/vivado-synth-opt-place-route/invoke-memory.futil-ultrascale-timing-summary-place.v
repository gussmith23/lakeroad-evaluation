Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:19:14 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing_summary -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//invoke-memory.futil-ultrascale-timing-summary-place.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Summary Report

------------------------------------------------------------------------------------------------
| Timer Settings
| --------------
------------------------------------------------------------------------------------------------

  Enable Multi Corner Analysis               :  Yes
  Enable Pessimism Removal                   :  Yes
  Pessimism Removal Resolution               :  Nearest Common Node
  Enable Input Delay Default Clock           :  No
  Enable Preset / Clear Arcs                 :  No
  Disable Flight Delays                      :  No
  Ignore I/O Paths                           :  No
  Timing Early Launch at Borrowing Latches   :  No
  Borrow Time for Max Delay Exceptions       :  Yes
  Merge Timing Exceptions                    :  Yes

  Corner  Analyze    Analyze    
  Name    Max Paths  Min Paths  
  ------  ---------  ---------  
  Slow    Yes        Yes        
  Fast    Yes        Yes        


------------------------------------------------------------------------------------------------
| Report Methodology
| ------------------
------------------------------------------------------------------------------------------------

No report available as report_methodology has not been run prior. Run report_methodology on the current design for the summary of methodology violations.



check_timing report

Table of Contents
-----------------
1. checking no_clock (0)
2. checking constant_clock (0)
3. checking pulse_width_clock (0)
4. checking unconstrained_internal_endpoints (0)
5. checking no_input_delay (3)
6. checking no_output_delay (40)
7. checking multiple_clock (0)
8. checking generated_clocks (0)
9. checking loops (0)
10. checking partial_input_delay (0)
11. checking partial_output_delay (0)
12. checking latch_loops (0)

1. checking no_clock (0)
------------------------
 There are 0 register/latch pins with no clock.


2. checking constant_clock (0)
------------------------------
 There are 0 register/latch pins with constant_clock.


3. checking pulse_width_clock (0)
---------------------------------
 There are 0 register/latch pins which need pulse_width check


4. checking unconstrained_internal_endpoints (0)
------------------------------------------------
 There are 0 pins that are not constrained for maximum delay.

 There are 0 pins that are not constrained for maximum delay due to constant clock.


5. checking no_input_delay (3)
------------------------------
 There are 3 input ports with no input delay specified. (HIGH)

 There are 0 input ports with no input delay but user has a false path constraint.


6. checking no_output_delay (40)
--------------------------------
 There are 40 ports with no output delay specified. (HIGH)

 There are 0 ports with no output delay but user has a false path constraint

 There are 0 ports with no output delay but with a timing clock defined on it or propagating through it


7. checking multiple_clock (0)
------------------------------
 There are 0 register/latch pins with multiple clocks.


8. checking generated_clocks (0)
--------------------------------
 There are 0 generated clocks that are not connected to a clock source.


9. checking loops (0)
---------------------
 There are 0 combinational loops in the design.


10. checking partial_input_delay (0)
------------------------------------
 There are 0 input ports with partial input delay specified.


11. checking partial_output_delay (0)
-------------------------------------
 There are 0 ports with partial output delay specified.


12. checking latch_loops (0)
----------------------------
 There are 0 combinational latch loops in the design through latch input



------------------------------------------------------------------------------------------------
| Design Timing Summary
| ---------------------
------------------------------------------------------------------------------------------------

    WNS(ns)      TNS(ns)  TNS Failing Endpoints  TNS Total Endpoints      WHS(ns)      THS(ns)  THS Failing Endpoints  THS Total Endpoints     WPWS(ns)     TPWS(ns)  TPWS Failing Endpoints  TPWS Total Endpoints  
    -------      -------  ---------------------  -------------------      -------      -------  ---------------------  -------------------     --------     --------  ----------------------  --------------------  
      3.510        0.000                      0                   15        0.060        0.000                      0                   15        2.225        0.000                       0                     9  


All user specified timing constraints are met.


------------------------------------------------------------------------------------------------
| Clock Summary
| -------------
------------------------------------------------------------------------------------------------

Clock  Waveform(ns)         Period(ns)      Frequency(MHz)
-----  ------------         ----------      --------------
clk    {0.000 2.500}        5.000           200.000         


------------------------------------------------------------------------------------------------
| Intra Clock Table
| -----------------
------------------------------------------------------------------------------------------------

Clock             WNS(ns)      TNS(ns)  TNS Failing Endpoints  TNS Total Endpoints      WHS(ns)      THS(ns)  THS Failing Endpoints  THS Total Endpoints     WPWS(ns)     TPWS(ns)  TPWS Failing Endpoints  TPWS Total Endpoints  
-----             -------      -------  ---------------------  -------------------      -------      -------  ---------------------  -------------------     --------     --------  ----------------------  --------------------  
clk                 3.510        0.000                      0                   15        0.060        0.000                      0                   15        2.225        0.000                       0                     9  


------------------------------------------------------------------------------------------------
| Inter Clock Table
| -----------------
------------------------------------------------------------------------------------------------

From Clock    To Clock          WNS(ns)      TNS(ns)  TNS Failing Endpoints  TNS Total Endpoints      WHS(ns)      THS(ns)  THS Failing Endpoints  THS Total Endpoints  
----------    --------          -------      -------  ---------------------  -------------------      -------      -------  ---------------------  -------------------  


------------------------------------------------------------------------------------------------
| Other Path Groups Table
| -----------------------
------------------------------------------------------------------------------------------------

Path Group    From Clock    To Clock          WNS(ns)      TNS(ns)  TNS Failing Endpoints  TNS Total Endpoints      WHS(ns)      THS(ns)  THS Failing Endpoints  THS Total Endpoints  
----------    ----------    --------          -------      -------  ---------------------  -------------------      -------      -------  ---------------------  -------------------  


------------------------------------------------------------------------------------------------
| Timing Details
| --------------
------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------
From Clock:  clk
  To Clock:  clk

Setup :            0  Failing Endpoints,  Worst Slack        3.510ns,  Total Violation        0.000ns
Hold  :            0  Failing Endpoints,  Worst Slack        0.060ns,  Total Violation        0.000ns
PW    :            0  Failing Endpoints,  Worst Slack        2.225ns,  Total Violation        0.000ns
---------------------------------------------------------------------------------------------------


Max Delay Paths
--------------------------------------------------------------------------------------
Slack (MET) :             3.510ns  (required time - arrival time)
  Source:                 copy0/fsm/out_reg[1]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            copy0/comb_reg/out_reg[0]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        1.470ns  (logic 0.725ns (49.320%)  route 0.745ns (50.680%))
  Logic Levels:           4  (CARRY8=1 LUT3=1 LUT5=1 LUT6=1)
  Clock Path Skew:        -0.012ns (DCD - SCD + CPR)
    Destination Clock Delay (DCD):    0.024ns = ( 5.024 - 5.000 ) 
    Source Clock Delay      (SCD):    0.036ns
    Clock Pessimism Removal (CPR):    0.000ns
  Clock Uncertainty:      0.035ns  ((TSJ^2 + TIJ^2)^1/2 + DJ) / 2 + PE
    Total System Jitter     (TSJ):    0.071ns
    Total Input Jitter      (TIJ):    0.000ns
    Discrete Jitter          (DJ):    0.000ns
    Phase Error              (PE):    0.000ns

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=8, unset)            0.036     0.036    copy0/fsm/clk
    SLICE_X21Y92         FDRE                                         r  copy0/fsm/out_reg[1]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X21Y92         FDRE (Prop_GFF_SLICEL_C_Q)
                                                      0.097     0.133 r  copy0/fsm/out_reg[1]/Q
                         net (fo=50, estimated)       0.256     0.389    copy0/fsm/fsm_out[1]
    SLICE_X21Y92         LUT5 (Prop_H5LUT_SLICEL_I0_O)
                                                      0.195     0.584 r  copy0/fsm/A_LUT_0_i_2__0/O
                         net (fo=6, estimated)        0.237     0.821    copy0/lt/_impl/C_LUT_2/I1
    SLICE_X21Y90         LUT6 (Prop_C6LUT_SLICEL_I1_O)
                                                      0.148     0.969 r  copy0/lt/_impl/C_LUT_2/LUT6/O
                         net (fo=1, routed)           0.011     0.980    copy0/lt/_impl/luts_O6_1[2]
    SLICE_X21Y90         CARRY8 (Prop_CARRY8_SLICEL_S[2]_CO[7])
                                                      0.196     1.176 r  copy0/lt/_impl/carry_8/CO[7]
                         net (fo=1, estimated)        0.215     1.391    copy0/lt/_impl/lt_out
    SLICE_X21Y92         LUT3 (Prop_B5LUT_SLICEL_I0_O)
                                                      0.089     1.480 r  copy0/lt/_impl/out[0]_i_1__0/O
                         net (fo=1, routed)           0.026     1.506    copy0/comb_reg/out_reg[0]_0
    SLICE_X21Y92         FDRE                                         r  copy0/comb_reg/out_reg[0]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=8, unset)            0.024     5.024    copy0/comb_reg/clk
    SLICE_X21Y92         FDRE                                         r  copy0/comb_reg/out_reg[0]/C
                         clock pessimism              0.000     5.024    
                         clock uncertainty           -0.035     4.989    
    SLICE_X21Y92         FDRE (Setup_BFF2_SLICEL_C_D)
                                                      0.027     5.016    copy0/comb_reg/out_reg[0]
  -------------------------------------------------------------------
                         required time                          5.016    
                         arrival time                          -1.506    
  -------------------------------------------------------------------
                         slack                                  3.510    





Min Delay Paths
--------------------------------------------------------------------------------------
Slack (MET) :             0.060ns  (arrival time - required time)
  Source:                 copy0/N/out_reg[1]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            copy0/N/out_reg[1]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Hold (Min at Fast Process Corner)
  Requirement:            0.000ns  (clk rise@0.000ns - clk rise@0.000ns)
  Data Path Delay:        0.112ns  (logic 0.071ns (63.393%)  route 0.041ns (36.607%))
  Logic Levels:           2  (CARRY8=1 LUT6=1)
  Clock Path Skew:        0.006ns (DCD - SCD - CPR)
    Destination Clock Delay (DCD):    0.018ns
    Source Clock Delay      (SCD):    0.012ns
    Clock Pessimism Removal (CPR):    -0.000ns

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=8, unset)            0.012     0.012    copy0/N/clk
    SLICE_X22Y91         FDRE                                         r  copy0/N/out_reg[1]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X22Y91         FDRE (Prop_BFF_SLICEL_C_Q)
                                                      0.039     0.051 r  copy0/N/out_reg[1]/Q
                         net (fo=3, estimated)        0.027     0.078    copy0/fsm/Q[1]
    SLICE_X22Y91         LUT6 (Prop_B6LUT_SLICEL_I5_O)
                                                      0.015     0.093 r  copy0/fsm/B_LUT_1_i_1/O
                         net (fo=1, routed)           0.007     0.100    copy0/add/_impl/a[1]
    SLICE_X22Y91         CARRY8 (Prop_CARRY8_SLICEL_S[1]_O[1])
                                                      0.017     0.117 r  copy0/add/_impl/carry_8/O[1]
                         net (fo=1, routed)           0.007     0.124    copy0/N/out0[1]
    SLICE_X22Y91         FDRE                                         r  copy0/N/out_reg[1]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=8, unset)            0.018     0.018    copy0/N/clk
    SLICE_X22Y91         FDRE                                         r  copy0/N/out_reg[1]/C
                         clock pessimism              0.000     0.018    
    SLICE_X22Y91         FDRE (Hold_BFF_SLICEL_C_D)
                                                      0.046     0.064    copy0/N/out_reg[1]
  -------------------------------------------------------------------
                         required time                         -0.064    
                         arrival time                           0.124    
  -------------------------------------------------------------------
                         slack                                  0.060    





Pulse Width Checks
--------------------------------------------------------------------------------------
Clock Name:         clk
Waveform(ns):       { 0.000 2.500 }
Period(ns):         5.000
Sources:            { clk }

Check Type        Corner  Lib Pin  Reference Pin  Required(ns)  Actual(ns)  Slack(ns)  Location      Pin
Min Period        n/a     FDRE/C   n/a            0.550         5.000       4.450      SLICE_X23Y91  copy0/N/done_reg/C
Low Pulse Width   Slow    FDRE/C   n/a            0.275         2.500       2.225      SLICE_X23Y91  copy0/N/done_reg/C
High Pulse Width  Slow    FDRE/C   n/a            0.275         2.500       2.225      SLICE_X23Y91  copy0/N/done_reg/C



