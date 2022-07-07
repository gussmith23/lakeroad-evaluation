Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:08:02 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing_summary -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//lpm.futil-vanilla-timing-summary-place.v
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
      1.911        0.000                      0                  863        0.037        0.000                      0                  863        2.225        0.000                       0                   654  


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
clk                 1.911        0.000                      0                  863        0.037        0.000                      0                  863        2.225        0.000                       0                   654  


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

Setup :            0  Failing Endpoints,  Worst Slack        1.911ns,  Total Violation        0.000ns
Hold  :            0  Failing Endpoints,  Worst Slack        0.037ns,  Total Violation        0.000ns
PW    :            0  Failing Endpoints,  Worst Slack        2.225ns,  Total Violation        0.000ns
---------------------------------------------------------------------------------------------------


Max Delay Paths
--------------------------------------------------------------------------------------
Slack (MET) :             1.911ns  (required time - arrival time)
  Source:                 tcam/pd55/out_reg[0]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            tcam/me1/r/out_reg[0]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        3.070ns  (logic 1.074ns (34.984%)  route 1.996ns (65.016%))
  Logic Levels:           7  (CARRY8=1 LUT4=2 LUT5=3 LUT6=1)
  Clock Path Skew:        -0.011ns (DCD - SCD + CPR)
    Destination Clock Delay (DCD):    0.025ns = ( 5.025 - 5.000 ) 
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
                         net (fo=653, unset)          0.036     0.036    tcam/pd55/clk
    SLICE_X33Y22         FDRE                                         r  tcam/pd55/out_reg[0]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X33Y22         FDRE (Prop_GFF_SLICEL_C_Q)
                                                      0.097     0.133 r  tcam/pd55/out_reg[0]/Q
                         net (fo=4, estimated)        0.230     0.363    tcam/pd55/pd55_out
    SLICE_X33Y28         LUT4 (Prop_B5LUT_SLICEL_I0_O)
                                                      0.202     0.565 r  tcam/pd55/done_i_10/O
                         net (fo=1, estimated)        0.248     0.813    tcam/pd36/done_i_3__2
    SLICE_X32Y26         LUT5 (Prop_E6LUT_SLICEL_I4_O)
                                                      0.039     0.852 r  tcam/pd36/done_i_6/O
                         net (fo=1, estimated)        0.191     1.043    tcam/pd61/out_reg[0]_0
    SLICE_X32Y20         LUT4 (Prop_C6LUT_SLICEL_I1_O)
                                                      0.098     1.141 r  tcam/pd61/done_i_3__2/O
                         net (fo=63, estimated)       0.536     1.677    tcam/l1/par0_done_in
    SLICE_X33Y35         LUT5 (Prop_D5LUT_SLICEL_I2_O)
                                                      0.080     1.757 r  tcam/l1/out_carry_i_15__0/O
                         net (fo=1, estimated)        0.211     1.968    tcam/fsm32/out_carry_6
    SLICE_X33Y36         LUT6 (Prop_A6LUT_SLICEL_I0_O)
                                                      0.178     2.146 r  tcam/fsm32/out_carry_i_8__0/O
                         net (fo=1, routed)           0.011     2.157    tcam/me1/eq/S[0]
    SLICE_X33Y36         CARRY8 (Prop_CARRY8_SLICEL_S[0]_CO[7])
                                                      0.238     2.395 r  tcam/me1/eq/out_carry/CO[7]
                         net (fo=1, estimated)        0.228     2.623    tcam/me1/r/CO[0]
    SLICE_X33Y34         LUT5 (Prop_B5LUT_SLICEL_I0_O)
                                                      0.142     2.765 r  tcam/me1/r/out[0]_i_1__0/O
                         net (fo=1, estimated)        0.341     3.106    tcam/me1/r/out[0]_i_1__0_n_0
    SLICE_X33Y34         FDRE                                         r  tcam/me1/r/out_reg[0]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=653, unset)          0.025     5.025    tcam/me1/r/clk
    SLICE_X33Y34         FDRE                                         r  tcam/me1/r/out_reg[0]/C
                         clock pessimism              0.000     5.025    
                         clock uncertainty           -0.035     4.990    
    SLICE_X33Y34         FDRE (Setup_EFF_SLICEL_C_D)
                                                      0.027     5.017    tcam/me1/r/out_reg[0]
  -------------------------------------------------------------------
                         required time                          5.017    
                         arrival time                          -3.106    
  -------------------------------------------------------------------
                         slack                                  1.911    





Min Delay Paths
--------------------------------------------------------------------------------------
Slack (MET) :             0.037ns  (arrival time - required time)
  Source:                 tcam/fsm11/out_reg[1]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            tcam/pd11/out_reg[0]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Hold (Min at Fast Process Corner)
  Requirement:            0.000ns  (clk rise@0.000ns - clk rise@0.000ns)
  Data Path Delay:        0.090ns  (logic 0.059ns (65.556%)  route 0.031ns (34.444%))
  Logic Levels:           1  (LUT4=1)
  Clock Path Skew:        0.006ns (DCD - SCD - CPR)
    Destination Clock Delay (DCD):    0.019ns
    Source Clock Delay      (SCD):    0.013ns
    Clock Pessimism Removal (CPR):    -0.000ns

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=653, unset)          0.013     0.013    tcam/fsm11/clk
    SLICE_X35Y37         FDRE                                         r  tcam/fsm11/out_reg[1]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X35Y37         FDRE (Prop_HFF_SLICEL_C_Q)
                                                      0.039     0.052 r  tcam/fsm11/out_reg[1]/Q
                         net (fo=2, estimated)        0.025     0.077    tcam/fsm11/fsm11_out[1]
    SLICE_X35Y37         LUT4 (Prop_H5LUT_SLICEL_I0_O)
                                                      0.020     0.097 r  tcam/fsm11/out[0]_i_1__262/O
                         net (fo=1, routed)           0.006     0.103    tcam/pd11/out_reg[0]_1
    SLICE_X35Y37         FDRE                                         r  tcam/pd11/out_reg[0]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=653, unset)          0.019     0.019    tcam/pd11/clk
    SLICE_X35Y37         FDRE                                         r  tcam/pd11/out_reg[0]/C
                         clock pessimism              0.000     0.019    
    SLICE_X35Y37         FDRE (Hold_HFF2_SLICEL_C_D)
                                                      0.047     0.066    tcam/pd11/out_reg[0]
  -------------------------------------------------------------------
                         required time                         -0.066    
                         arrival time                           0.103    
  -------------------------------------------------------------------
                         slack                                  0.037    





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



