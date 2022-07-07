Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:08:07 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing_summary -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//lpm.futil-vanilla-timing-summary-route.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
6. checking no_output_delay (7)
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


6. checking no_output_delay (7)
-------------------------------
 There are 7 ports with no output delay specified. (HIGH)

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
      1.432        0.000                      0                  863        0.042        0.000                      0                  863        2.225        0.000                       0                   654  


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
clk                 1.432        0.000                      0                  863        0.042        0.000                      0                  863        2.225        0.000                       0                   654  


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

Setup :            0  Failing Endpoints,  Worst Slack        1.432ns,  Total Violation        0.000ns
Hold  :            0  Failing Endpoints,  Worst Slack        0.042ns,  Total Violation        0.000ns
PW    :            0  Failing Endpoints,  Worst Slack        2.225ns,  Total Violation        0.000ns
---------------------------------------------------------------------------------------------------


Max Delay Paths
--------------------------------------------------------------------------------------
Slack (MET) :             1.432ns  (required time - arrival time)
  Source:                 tcam/pd63/out_reg[0]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            tcam/ce07/addr/out_reg[3]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        3.550ns  (logic 0.649ns (18.282%)  route 2.901ns (81.718%))
  Logic Levels:           5  (LUT4=3 LUT5=1 LUT6=1)
  Clock Path Skew:        -0.010ns (DCD - SCD + CPR)
    Destination Clock Delay (DCD):    0.025ns = ( 5.025 - 5.000 ) 
    Source Clock Delay      (SCD):    0.035ns
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
                         net (fo=653, unset)          0.035     0.035    tcam/pd63/clk
    SLICE_X30Y33         FDRE                                         r  tcam/pd63/out_reg[0]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X30Y33         FDRE (Prop_AFF_SLICEL_C_Q)
                                                      0.096     0.131 f  tcam/pd63/out_reg[0]/Q
                         net (fo=11, routed)          0.489     0.620    tcam/pd78/pd63_out
    SLICE_X30Y17         LUT4 (Prop_H6LUT_SLICEL_I1_O)
                                                      0.179     0.799 f  tcam/pd78/out[0]_i_4__10/O
                         net (fo=1, routed)           0.244     1.043    tcam/pd73/out_reg[0]_0
    SLICE_X28Y17         LUT4 (Prop_H6LUT_SLICEM_I1_O)
                                                      0.117     1.160 f  tcam/pd73/out[0]_i_2__86/O
                         net (fo=30, routed)          0.789     1.949    tcam/fsm32/par1_done_in
    SLICE_X33Y30         LUT5 (Prop_G6LUT_SLICEL_I1_O)
                                                      0.063     2.012 r  tcam/fsm32/done_i_2__22/O
                         net (fo=113, routed)         0.843     2.855    tcam/ce07/fsm/par1_go_in
    SLICE_X26Y21         LUT6 (Prop_F6LUT_SLICEL_I2_O)
                                                      0.114     2.969 r  tcam/ce07/fsm/done_i_2__4/O
                         net (fo=6, routed)           0.159     3.128    tcam/ce07/fsm/done_i_2__4_n_0
    SLICE_X26Y22         LUT4 (Prop_D5LUT_SLICEL_I3_O)
                                                      0.080     3.208 r  tcam/ce07/fsm/done_i_1__19/O
                         net (fo=4, routed)           0.377     3.585    tcam/ce07/addr/D[1]
    SLICE_X26Y21         FDRE                                         r  tcam/ce07/addr/out_reg[3]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=653, unset)          0.025     5.025    tcam/ce07/addr/clk
    SLICE_X26Y21         FDRE                                         r  tcam/ce07/addr/out_reg[3]/C
                         clock pessimism              0.000     5.025    
                         clock uncertainty           -0.035     4.990    
    SLICE_X26Y21         FDRE (Setup_GFF_SLICEL_C_D)
                                                      0.027     5.017    tcam/ce07/addr/out_reg[3]
  -------------------------------------------------------------------
                         required time                          5.017    
                         arrival time                          -3.585    
  -------------------------------------------------------------------
                         slack                                  1.432    





Min Delay Paths
--------------------------------------------------------------------------------------
Slack (MET) :             0.042ns  (arrival time - required time)
  Source:                 tcam/ce012/fsm0/out_reg[0]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            tcam/ce012/fsm0/out_reg[0]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Hold (Min at Fast Process Corner)
  Requirement:            0.000ns  (clk rise@0.000ns - clk rise@0.000ns)
  Data Path Delay:        0.094ns  (logic 0.054ns (57.447%)  route 0.040ns (42.553%))
  Logic Levels:           1  (LUT5=1)
  Clock Path Skew:        0.006ns (DCD - SCD - CPR)
    Destination Clock Delay (DCD):    0.018ns
    Source Clock Delay      (SCD):    0.012ns
    Clock Pessimism Removal (CPR):    -0.000ns

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=653, unset)          0.012     0.012    tcam/ce012/fsm0/clk
    SLICE_X36Y19         FDRE                                         r  tcam/ce012/fsm0/out_reg[0]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X36Y19         FDRE (Prop_BFF_SLICEL_C_Q)
                                                      0.039     0.051 f  tcam/ce012/fsm0/out_reg[0]/Q
                         net (fo=7, routed)           0.025     0.076    tcam/ce012/pd0/out_reg[0]_2
    SLICE_X36Y19         LUT5 (Prop_B6LUT_SLICEL_I4_O)
                                                      0.015     0.091 r  tcam/ce012/pd0/out[0]_i_1__112/O
                         net (fo=1, routed)           0.015     0.106    tcam/ce012/fsm0/out_reg[0]_2
    SLICE_X36Y19         FDRE                                         r  tcam/ce012/fsm0/out_reg[0]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=653, unset)          0.018     0.018    tcam/ce012/fsm0/clk
    SLICE_X36Y19         FDRE                                         r  tcam/ce012/fsm0/out_reg[0]/C
                         clock pessimism              0.000     0.018    
    SLICE_X36Y19         FDRE (Hold_BFF_SLICEL_C_D)
                                                      0.046     0.064    tcam/ce012/fsm0/out_reg[0]
  -------------------------------------------------------------------
                         required time                         -0.064    
                         arrival time                           0.106    
  -------------------------------------------------------------------
                         slack                                  0.042    





Pulse Width Checks
--------------------------------------------------------------------------------------
Clock Name:         clk
Waveform(ns):       { 0.000 2.500 }
Period(ns):         5.000
Sources:            { clk }

Check Type        Corner  Lib Pin  Reference Pin  Required(ns)  Actual(ns)  Slack(ns)  Location      Pin
Min Period        n/a     FDRE/C   n/a            0.550         5.000       4.450      SLICE_X37Y30  fsm/out_reg[0]/C
Low Pulse Width   Slow    FDRE/C   n/a            0.275         2.500       2.225      SLICE_X37Y30  fsm/out_reg[0]/C
High Pulse Width  Slow    FDRE/C   n/a            0.275         2.500       2.225      SLICE_X37Y30  fsm/out_reg[0]/C



